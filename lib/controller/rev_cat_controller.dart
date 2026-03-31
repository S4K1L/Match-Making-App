import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

/// Reusable RevenueCat GetX controller.
///
/// Drop-in for any Flutter + GetX project that depends on `purchases_flutter`
/// and `purchases_ui_flutter`. All project-specific identifiers live in
/// [AppConstants] so this file needs no edits between projects.
///
/// ─── Lifecycle ───────────────────────────────────────────────────────────────
///   onInit()               → anonymous bootstrap on app start
///   onUserAuthenticated()  → call after login (email or userId both work)
///   onUserLogout()         → call on logout / account deletion
///
/// ─── Purchase flow ───────────────────────────────────────────────────────────
///   purchasePackage(packageName, offeringName, signInInfo?)
///   restorePackage()
///
/// ─── Paywall / Customer Center ───────────────────────────────────────────────
///   showPaywallIfNeeded()
///   openCustomerCenter()
class RevCatController extends GetxController {
  // ─── Observable state ──────────────────────────────────────────────────────

  final isConfigured = false.obs;

  /// True while offerings / customer-info are loading.
  final isLoading = false.obs;

  /// True while a purchase sheet is open.
  final isPurchasing = false.obs;

  /// True while a restore is in progress.
  final isRestoring = false.obs;

  /// Package identifier of the card whose purchase is currently running.
  /// Use this to show a per-card spinner: `activePackageId == RC_PACKAGE_ELITE`.
  final activePackageId = ''.obs;

  /// Latest customer info from RevenueCat.
  final customerInfo = Rxn<CustomerInfo>();

  /// All offerings fetched from the RC dashboard.
  final offerings = Rxn<Offerings>();

  /// Last user-facing error; empty string when clean.
  final lastError = ''.obs;

  // ─── Private ───────────────────────────────────────────────────────────────

  String? _appleApiKey;
  String? _googleApiKey;

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    // Anonymous bootstrap — no userId yet. Call onUserAuthenticated() after login.
    initRevCat(
      appleApiKey: AppConstants.RC_APPLE_API_KEY,
      googleApiKey: AppConstants.RC_GOOGLE_API_KEY,
    );
  }

  @override
  void onClose() {
    Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdated);
    super.onClose();
  }

  // ─── Core initialisation ───────────────────────────────────────────────────

  /// Initialises (or re-identifies) the RevenueCat SDK.
  ///
  /// Safe to call multiple times — will not re-configure if already set up,
  /// but will log in the user and refresh state when [signInInfo] is provided.
  ///
  /// [signInInfo] accepts either a numeric userId or an email address.
  Future<void> initRevCat({
    required String appleApiKey,
    required String googleApiKey,
    String? signInInfo,
  }) async {
    if (!Platform.isIOS && !Platform.isAndroid) return;

    _appleApiKey = appleApiKey;
    _googleApiKey = googleApiKey;

    isLoading.value = true;
    lastError.value = '';

    try {
      await Purchases.setLogLevel(
        kDebugMode ? LogLevel.debug : LogLevel.warn,
      );

      final alreadyConfigured = await Purchases.isConfigured;

      if (!alreadyConfigured) {
        final apiKey = Platform.isIOS ? appleApiKey : googleApiKey;
        final config = PurchasesConfiguration(apiKey);

        // Embed user identity at configure time when available to avoid an
        // anonymous → identified alias call immediately after.
        if (signInInfo != null && signInInfo.isNotEmpty) {
          config.appUserID = signInInfo;
        }

        await Purchases.configure(config);
        Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);
      }

      isConfigured.value = true;

      // If SDK was already configured but a new user identity is supplied
      // (e.g. user just logged in), log them in now.
      if (signInInfo != null && signInInfo.isNotEmpty) {
        await Purchases.logIn(signInInfo);
      }

      await _refreshAll();
    } catch (e) {
      lastError.value = _errorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Auth integration ──────────────────────────────────────────────────────

  /// Call this after your user logs in.
  ///
  /// [signInInfo] can be a userId (int or string) or an email — RevenueCat
  /// accepts any non-empty string as an App User ID.
  Future<void> onUserAuthenticated(String signInInfo) async {
    if (signInInfo.isEmpty) return;

    if (!isConfigured.value) {
      // First launch — SDK not yet configured; do a full init with identity.
      await initRevCat(
        appleApiKey: _appleApiKey ?? AppConstants.RC_APPLE_API_KEY,
        googleApiKey: _googleApiKey ?? AppConstants.RC_GOOGLE_API_KEY,
        signInInfo: signInInfo,
      );
      return;
    }

    isLoading.value = true;
    lastError.value = '';
    try {
      await Purchases.logIn(signInInfo);
      await _refreshAll();
    } catch (e) {
      lastError.value = _errorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Call this on logout or account deletion to reset RevenueCat to anonymous.
  Future<void> onUserLogout() async {
    if (!isConfigured.value) return;
    try {
      await Purchases.logOut();
      customerInfo.value = null;
      _syncIsSubscribed(null);
    } catch (_) {}
  }

  // ─── Purchase ──────────────────────────────────────────────────────────────

  /// Purchases [packageName] from the offering identified by [offeringName].
  ///
  /// - [packageName]  : `AppConstants.RC_PACKAGE_*` constant, or any RC
  ///                    package identifier / type alias (monthly, annual…).
  /// - [offeringName] : defaults to `AppConstants.RC_OFFERING` (`'default'`).
  ///                    Use `'current'` to resolve the RC-configured current
  ///                    offering instead.
  /// - [signInInfo]   : optional — logs the user in right before the purchase.
  ///
  /// Returns updated [CustomerInfo] on success, `null` on cancel or error.
  Future<CustomerInfo?> purchasePackage({
    required String packageName,
    String offeringName = AppConstants.RC_OFFERING,
    String? signInInfo,
  }) async {
    _assertConfigured('purchasePackage');

    lastError.value = '';

    if (signInInfo != null && signInInfo.isNotEmpty) {
      await Purchases.logIn(signInInfo);
    }

    final offering = _resolveOffering(offeringName);
    if (offering == null) {
      lastError.value = 'Offering "$offeringName" not found. '
          'Verify the identifier in the RevenueCat dashboard and make sure '
          'initRevCat() has been called first.';
      return null;
    }

    final package = _resolvePackage(packageName, offering);
    if (package == null) {
      lastError.value = 'Package "$packageName" not found in '
          'offering "${offering.identifier}".';
      return null;
    }

    isPurchasing.value = true;
    activePackageId.value = packageName;
    try {
      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      customerInfo.value = result.customerInfo;
      _syncIsSubscribed(result.customerInfo);
      return result.customerInfo;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code != PurchasesErrorCode.purchaseCancelledError) {
        lastError.value = _errorMessage(e);
      }
      return null;
    } catch (e) {
      lastError.value = _errorMessage(e);
      return null;
    } finally {
      activePackageId.value = '';
      isPurchasing.value = false;
    }
  }

  /// Restores previous purchases from the store account.
  ///
  /// **Must be called from a user tap** — may trigger an OS sign-in prompt.
  /// Returns updated [CustomerInfo], or `null` on error.
  Future<CustomerInfo?> restorePackage() async {
    _assertConfigured('restorePackage');

    isRestoring.value = true;
    lastError.value = '';
    try {
      final info = await Purchases.restorePurchases();
      customerInfo.value = info;
      _syncIsSubscribed(info);
      return info;
    } on PlatformException catch (e) {
      lastError.value = _errorMessage(e);
      return null;
    } catch (e) {
      lastError.value = _errorMessage(e);
      return null;
    } finally {
      isRestoring.value = false;
    }
  }

  // ─── Paywall / Customer Center ─────────────────────────────────────────────

  /// Shows the RevenueCat paywall only if none of the app's entitlements
  /// are currently active.
  ///
  /// RevenueCatUI requires a single entitlement identifier to decide whether
  /// to suppress the paywall. We pass the highest-tier entitlement and also
  /// check the other two ourselves so any active tier skips the paywall.
  Future<PaywallResult> showPaywallIfNeeded() async {
    _assertConfigured('showPaywallIfNeeded');
    if (isSubscribed) return PaywallResult.notPresented;
    try {
      final result = await RevenueCatUI.presentPaywallIfNeeded(
        AppConstants.RC_ENTITLEMENT_ELITE,
        offering: offerings.value?.all[AppConstants.RC_OFFERING]
            ?? offerings.value?.current,
        displayCloseButton: true,
      );
      await _refreshAll();
      return result;
    } catch (e) {
      lastError.value = _errorMessage(e);
      return PaywallResult.error;
    }
  }

  /// Opens the RevenueCat Customer Center (manage / cancel subscription).
  Future<void> openCustomerCenter() async {
    _assertConfigured('openCustomerCenter');
    try {
      await RevenueCatUI.presentCustomerCenter();
      await _refreshAll();
    } catch (e) {
      lastError.value = _errorMessage(e);
    }
  }

  // ─── Convenience helpers ───────────────────────────────────────────────────

  /// Returns `true` if [entitlementId] is currently active.
  bool isEntitlementActive(String entitlementId) {
    return customerInfo.value?.entitlements.active.containsKey(entitlementId)
        ?? false;
  }

  /// Per-tier entitlement shorthands.
  bool get isSocietyActive  => isEntitlementActive(AppConstants.RC_ENTITLEMENT_SOCIETY);
  bool get isPremiumActive  => isEntitlementActive(AppConstants.RC_ENTITLEMENT_PREMIUM);
  bool get isEliteActive    => isEntitlementActive(AppConstants.RC_ENTITLEMENT_ELITE);

  /// `true` if the user holds any active subscription tier.
  bool get isSubscribed => isSocietyActive || isPremiumActive || isEliteActive;

  /// Returns the active tier label, or `null` when not subscribed.
  String? get activeTierLabel {
    if (isEliteActive)   return 'ELITE';
    if (isPremiumActive) return 'PREMIUM';
    if (isSocietyActive) return 'SOCIETY';
    return null;
  }

  /// Returns the formatted price string for [packageId] in
  /// [AppConstants.RC_OFFERING], e.g. `'$9.99'`.
  /// Returns an empty string if offerings have not been fetched yet.
  String priceLabelFor(String packageId) {
    final offering = _resolveOffering(AppConstants.RC_OFFERING);
    if (offering == null) return '';
    return _resolvePackage(packageId, offering)?.storeProduct.priceString ?? '';
  }

  /// Returns the [Offering] for [offeringName], or `null`.
  /// Use `'current'` for the RC-configured default offering.
  Offering? getOffering(String offeringName) => _resolveOffering(offeringName);

  /// All available offerings keyed by their identifier.
  Map<String, Offering> get allOfferings => offerings.value?.all ?? {};

  // ─── Private ───────────────────────────────────────────────────────────────

  Future<void> _refreshAll() async {
    final all = await Purchases.getOfferings();
    offerings.value = all;
    final info = await Purchases.getCustomerInfo();
    _onCustomerInfoUpdated(info);
  }

  void _onCustomerInfoUpdated(CustomerInfo info) {
    customerInfo.value = info;
    _syncIsSubscribed(info);
  }

  /// Mirrors the subscription status to [UserController.isSubscribed] so the
  /// rest of the app stays reactive without importing RevCatController
  /// everywhere. The try-catch keeps this controller portable — it silently
  /// does nothing in projects that don't have UserController.
  void _syncIsSubscribed(CustomerInfo? info) {
    final active = info?.entitlements.active ?? {};
    final subscribed = AppConstants.RC_ENTITLEMENTS.any(active.containsKey);
    try {
      Get.find<UserController>().isSubscribed.value = subscribed;
    } catch (_) {}
  }

  void _assertConfigured(String method) {
    if (!isConfigured.value) {
      throw StateError(
        'RevCatController.$method() called before initRevCat(). '
        'Await initRevCat() or onUserAuthenticated() first.',
      );
    }
  }

  Offering? _resolveOffering(String offeringName) {
    final all = offerings.value;
    if (all == null) return null;
    if (offeringName == 'current') return all.current;
    return all.all[offeringName];
  }

  /// Resolves a package by name, trying convenience typed properties first
  /// then falling back to the raw identifier lookup. Case-insensitive.
  Package? _resolvePackage(String packageName, Offering offering) {
    final normalised = packageName.toLowerCase().replaceAll(r'$rc_', '');
    switch (normalised) {
      case 'weekly':
        return offering.weekly ?? offering.getPackage(packageName);
      case 'monthly':
        return offering.monthly ?? offering.getPackage(packageName);
      case 'annual':
      case 'yearly':
        return offering.annual ?? offering.getPackage(packageName);
      case 'sixmonth':
      case 'six_month':
        return offering.sixMonth ?? offering.getPackage(packageName);
      case 'threemonth':
      case 'three_month':
        return offering.threeMonth ?? offering.getPackage(packageName);
      case 'twomonth':
      case 'two_month':
        return offering.twoMonth ?? offering.getPackage(packageName);
      case 'lifetime':
        return offering.lifetime ?? offering.getPackage(packageName);
      default:
        // Custom identifier (e.g. 'elite', 'premium', 'society')
        return offering.getPackage(packageName);
    }
  }

  String _errorMessage(Object error) {
    if (error is PlatformException) {
      final code = PurchasesErrorHelper.getErrorCode(error);
      switch (code) {
        case PurchasesErrorCode.purchaseCancelledError:
          return 'Purchase cancelled.';
        case PurchasesErrorCode.purchaseNotAllowedError:
          return 'Purchases are not allowed on this device.';
        case PurchasesErrorCode.paymentPendingError:
          return 'Payment is pending approval (Ask to Buy).';
        case PurchasesErrorCode.productAlreadyPurchasedError:
          return 'You already own this product.';
        case PurchasesErrorCode.receiptAlreadyInUseError:
          return 'This purchase is already linked to another account.';
        case PurchasesErrorCode.networkError:
          return 'Network error. Please check your connection and try again.';
        default:
          return error.message ?? 'Purchase failed. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}
