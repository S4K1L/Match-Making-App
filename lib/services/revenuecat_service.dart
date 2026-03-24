import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class RevenueCatService {
  static bool _isConfigured = false;

  static Future<void> configure({String? appUserId}) async {
    if (_isConfigured) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;
    if (ApiConstant.REVENUECAT_API_KEY.isEmpty) return;

    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.warn);

    final config = PurchasesConfiguration(ApiConstant.REVENUECAT_API_KEY);
    if (appUserId != null && appUserId.isNotEmpty) {
      config.appUserID = appUserId;
    }

    await Purchases.configure(config);
    _isConfigured = true;
  }

  static Future<void> logIn(String appUserId) async {
    await configure();
    if (appUserId.isEmpty) return;
    await Purchases.logIn(appUserId);
  }

  static Future<void> logOut() async {
    if (!_isConfigured) return;
    await Purchases.logOut();
  }

  static Future<Offerings> getOfferings() async {
    await configure();
    return Purchases.getOfferings();
  }

  static Future<CustomerInfo> getCustomerInfo() async {
    await configure();
    return Purchases.getCustomerInfo();
  }

  static Future<CustomerInfo> purchasePackage(Package package) async {
    await configure();
    final result = await Purchases.purchase(
      PurchaseParams.package(package),
    );
    return result.customerInfo;
  }

  static Future<CustomerInfo> restorePurchases() async {
    await configure();
    return Purchases.restorePurchases();
  }

  static bool hasBlinkPro(CustomerInfo customerInfo) {
    return customerInfo.entitlements.active
        .containsKey(ApiConstant.REVENUECAT_ENTITLEMENT_BLINK_PRO);
  }

  static Future<PaywallResult> presentPaywallIfNeeded({Offering? offering}) async {
    await configure();
    return RevenueCatUI.presentPaywallIfNeeded(
      ApiConstant.REVENUECAT_ENTITLEMENT_BLINK_PRO,
      offering: offering,
      displayCloseButton: true,
    );
  }

  static Future<PaywallResult> presentPaywall({Offering? offering}) async {
    await configure();
    return RevenueCatUI.presentPaywall(
      offering: offering,
      displayCloseButton: true,
    );
  }

  static Future<void> presentCustomerCenter() async {
    await configure();
    await RevenueCatUI.presentCustomerCenter();
  }

  static String messageFromError(Object error) {
    if (error is PlatformException) {
      final code = PurchasesErrorHelper.getErrorCode(error);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return 'Purchase cancelled.';
      }
      return error.message ?? 'Purchase failed. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
