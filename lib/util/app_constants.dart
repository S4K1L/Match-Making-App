// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import '../model/language_model.dart';

class AppConstants {
  static const String APP_NAME = 'Match Macking ';
  static const double APP_VERSION = 1.0;

  // ─── RevenueCat ────────────────────────────────────────────────────────────
  /// iOS app-specific API key from the RevenueCat dashboard.
  static const String RC_APPLE_API_KEY = 'appl_UbGiZqPBpMNfCdGQayNXpnTnhEu';
  /// Android app-specific API key from the RevenueCat dashboard.
  static const String RC_GOOGLE_API_KEY = 'goog_meLzQTCxpyoUVXIJSPkchRYMMNP';
  /// Offering identifier configured in the RevenueCat dashboard.
  static const String RC_OFFERING = 'default';
  /// Entitlement identifiers — one per subscription tier.
  static const String RC_ENTITLEMENT_SOCIETY = 'society';
  static const String RC_ENTITLEMENT_PREMIUM = 'premium';
  static const String RC_ENTITLEMENT_ELITE   = 'elite';
  /// All entitlements in tier order (lowest → highest).
  static const List<String> RC_ENTITLEMENTS = [
    RC_ENTITLEMENT_SOCIETY,
    RC_ENTITLEMENT_PREMIUM,
    RC_ENTITLEMENT_ELITE,
  ];
  /// Package identifiers inside the offering.
  static const String RC_PACKAGE_SOCIETY = 'society';
  static const String RC_PACKAGE_PREMIUM = 'premium';
  static const String RC_PACKAGE_ELITE   = 'elite';
  // ──────────────────────────────────────────────────────────────────────────

  static const String TOKEN = "token";
  static const String onesignalAppId = "token";

  // share preference Key
  static String THEME = "theme";
  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';
  static const String PUSH_NOTIFICATION_ENABLED = 'push_notification_enabled';

  static RegExp emailValidator = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static RegExp passwordValidator = RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
  );

  static List<LanguageModel> languages = [
    LanguageModel(
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel(
      languageName: 'Spanish',
      countryCode: 'ES',
      languageCode: 'es',
    ),
  ];
}
