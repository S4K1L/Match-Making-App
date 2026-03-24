import 'dart:convert';
import 'dart:io';

import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/services/revenuecat_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class SubscriptionController extends GetxController {
  final ApiService _api = ApiService();
  final isLoading = false.obs;
  final isPurchasing = false.obs;
  final activePackageId = ''.obs;
  final isBlinkProActive = false.obs;
  final lastError = ''.obs;
  final currentOffering = Rxn<Offering>();

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await RevenueCatService.configure();
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);
      await refreshSubscriptionState();
    } catch (e) {
      lastError.value = RevenueCatService.messageFromError(e);
    }
  }

  @override
  void onClose() {
    Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdated);
    super.onClose();
  }

  void _onCustomerInfoUpdated(CustomerInfo customerInfo) {
    isBlinkProActive.value = RevenueCatService.hasBlinkPro(customerInfo);
    Get.find<UserController>().isSubscribed.value = isBlinkProActive.value;
    syncSubscriptionToDatabase(customerInfo: customerInfo, source: 'listener');
  }

  Future<void> onUserAuthenticated(String appUserId) async {
    try {
      await RevenueCatService.logIn(appUserId);
      await refreshSubscriptionState();
      await syncSubscriptionToDatabase(source: 'login');
    } catch (e) {
      lastError.value = RevenueCatService.messageFromError(e);
    }
  }

  Future<void> onUserLogout() async {
    try {
      await RevenueCatService.logOut();
      isBlinkProActive.value = false;
      Get.find<UserController>().isSubscribed.value = false;
    } catch (_) {}
  }

  Future<void> refreshSubscriptionState() async {
    isLoading.value = true;
    lastError.value = '';
    try {
      final offerings = await RevenueCatService.getOfferings();
      currentOffering.value = offerings.current ?? offerings.all.values.firstOrNull;
      final customerInfo = await RevenueCatService.getCustomerInfo();
      _onCustomerInfoUpdated(customerInfo);
      await syncSubscriptionToDatabase(
        customerInfo: customerInfo,
        source: 'refresh',
      );
    } catch (e) {
      lastError.value = RevenueCatService.messageFromError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Package? get weeklyPackage => _findPackage(ApiConstant.REVENUECAT_PACKAGE_WEEKLY);
  Package? get monthlyPackage => _findPackage(ApiConstant.REVENUECAT_PACKAGE_MONTHLY);
  Package? get yearlyPackage => _findPackage(ApiConstant.REVENUECAT_PACKAGE_YEARLY);

  String priceLabelFor(String packageId) {
    final package = _findPackage(packageId);
    if (package == null) return 'Unavailable';
    return package.storeProduct.priceString;
  }

  Future<bool> purchasePlan(String packageId) async {
    final package = _findPackage(packageId);
    if (package == null) {
      lastError.value = 'This plan is not available right now.';
      return false;
    }

    isPurchasing.value = true;
    activePackageId.value = packageId;
    lastError.value = '';
    try {
      final customerInfo = await RevenueCatService.purchasePackage(package);
      _onCustomerInfoUpdated(customerInfo);
      await syncSubscriptionToDatabase(
        customerInfo: customerInfo,
        source: 'purchase:$packageId',
      );
      return isBlinkProActive.value;
    } catch (e) {
      lastError.value = RevenueCatService.messageFromError(e);
      return false;
    } finally {
      activePackageId.value = '';
      isPurchasing.value = false;
    }
  }

  Future<PaywallResult> showPaywallIfNeeded() async {
    try {
      final result = await RevenueCatService.presentPaywallIfNeeded(
        offering: currentOffering.value,
      );
      await refreshSubscriptionState();
      return result;
    } catch (e) {
      lastError.value = RevenueCatService.messageFromError(e);
      return PaywallResult.error;
    }
  }

  Future<void> restore() async {
    isLoading.value = true;
    try {
      final customerInfo = await RevenueCatService.restorePurchases();
      _onCustomerInfoUpdated(customerInfo);
      await syncSubscriptionToDatabase(
        customerInfo: customerInfo,
        source: 'restore',
      );
    } catch (e) {
      lastError.value = RevenueCatService.messageFromError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openCustomerCenter() async {
    try {
      await RevenueCatService.presentCustomerCenter();
      await refreshSubscriptionState();
    } catch (e) {
      lastError.value = RevenueCatService.messageFromError(e);
    }
  }

  Future<String> syncSubscriptionToDatabase({
    CustomerInfo? customerInfo,
    String source = 'manual',
  }) async {
    try {
      final currentInfo =
          customerInfo ?? await RevenueCatService.getCustomerInfo();
      final user = Get.find<UserController>().userInfo.value;

      final activeEntitlements = currentInfo.entitlements.active.map(
        (key, value) => MapEntry(key, _entitlementToJson(value)),
      );
      final allEntitlements = currentInfo.entitlements.all.map(
        (key, value) => MapEntry(key, _entitlementToJson(value)),
      );

      final payload = <String, dynamic>{
        'source': source,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'app_user_id': currentInfo.originalAppUserId,
        'user_id': user?.userId,
        'entitlement_id': ApiConstant.REVENUECAT_ENTITLEMENT_BLINK_PRO,
        'is_blink_pro_active': RevenueCatService.hasBlinkPro(currentInfo),
        'active_subscriptions': currentInfo.activeSubscriptions,
        'all_purchased_product_identifiers':
            currentInfo.allPurchasedProductIdentifiers,
        'all_purchase_dates': currentInfo.allPurchaseDates,
        'all_expiration_dates': currentInfo.allExpirationDates,
        'latest_expiration_date': currentInfo.latestExpirationDate,
        'management_url': currentInfo.managementURL,
        'request_date': currentInfo.requestDate,
        'original_app_user_id': currentInfo.originalAppUserId,
        'entitlements': {
          'active': activeEntitlements,
          'all': allEntitlements,
        },
      };

      final response = await _api.post(
        ApiConstant.revenueCatSubscriptionSync,
        payload,
        authReq: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'success';
      }

      final body = jsonDecode(response.body);
      return body is Map<String, dynamic>
          ? (body['message'] ?? 'Unable to sync subscription.')
          : 'Unable to sync subscription.';
    } catch (e) {
      return 'Unable to sync subscription.';
    }
  }

  Map<String, dynamic> _entitlementToJson(EntitlementInfo entitlement) {
    return {
      'identifier': entitlement.identifier,
      'is_active': entitlement.isActive,
      'will_renew': entitlement.willRenew,
      'latest_purchase_date': entitlement.latestPurchaseDate,
      'original_purchase_date': entitlement.originalPurchaseDate,
      'product_identifier': entitlement.productIdentifier,
      'is_sandbox': entitlement.isSandbox,
      'ownership_type': entitlement.ownershipType.name,
      'store': entitlement.store.name,
      'period_type': entitlement.periodType.name,
      'expiration_date': entitlement.expirationDate,
      'unsubscribe_detected_at': entitlement.unsubscribeDetectedAt,
      'billing_issue_detected_at': entitlement.billingIssueDetectedAt,
      'product_plan_identifier': entitlement.productPlanIdentifier,
      'verification': entitlement.verification.name,
    };
  }

  Package? _findPackage(String packageId) {
    final offering = currentOffering.value;
    if (offering == null) return null;

    if (packageId == ApiConstant.REVENUECAT_PACKAGE_WEEKLY) {
      return offering.getPackage(packageId) ?? offering.weekly;
    }
    if (packageId == ApiConstant.REVENUECAT_PACKAGE_MONTHLY) {
      return offering.getPackage(packageId) ?? offering.monthly;
    }
    if (packageId == ApiConstant.REVENUECAT_PACKAGE_YEARLY) {
      return offering.getPackage(packageId) ?? offering.annual;
    }
    return offering.getPackage(packageId);
  }
}
