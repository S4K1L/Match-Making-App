// ignore_for_file: constant_identifier_names

class ApiConstant {
  // Google Cloud OAuth 2.0 Web Client ID (not Android client ID).
  // Needed to reliably receive idToken on Android with google_sign_in.
  static const String GOOGLE_WEB_CLIENT_ID = '817979237192-168vv8j0upk6ar1ndkfc45se751jbpm3.apps.googleusercontent.com';
  static const String REVENUECAT_API_KEY = 'test_fObPiAkjoiwTJdSXpZXGbxDAGSC';
  static const String REVENUECAT_ENTITLEMENT_BLINK_PRO = 'BLINK Pro';
  static const String REVENUECAT_PACKAGE_WEEKLY = 'weekly';
  static const String REVENUECAT_PACKAGE_MONTHLY = 'monthly';
  static const String REVENUECAT_PACKAGE_YEARLY = 'yearly';

  static const String BASE_URL = 'http://10.10.12.111:8000/v1/';
  static const String BASE_URL_SOCKET =
      'ws://10.10.12.111:8000/ws/call/?token=';
  static const String BASE_URL_IMAGE = 'http://10.10.12.111:8000';

  static const String signUp = 'account/signup/';
  static const String verifyOtpRegistration =
      'account/verify-otp/registration/';
  static const String resendOtp = 'account/resend-otp/';
  static const String login = 'account/login/';
  static const String forgotPassword = 'account/forget-password/';
  static const String verifyForgotPassword = 'account/password/verify-otp/';
  static const String resetPassword = 'account/reset-password/';
  static const String updateProfile = 'account/profile/update/';
  static const String profileDetails = 'account/profile/details/';

  ///
  static const mutualSystemBlock = 'mutual-system/block/';
  static const mutualSystemUnblock = 'mutual-system/unblock/';
  static const mutualSystemBlockList = 'mutual-system/block-list/';
  static const mutualSystemReports = 'mutual-system/reports/';
  static const mutualSystemAdminAggregatedReports =
      'mutual-system/admin/reports/aggregated/';

  static const mutualSystemCreateStory = 'mutual-system/create/story/';
  static const mutualSystemMyStory = 'mutual-system/my/story/';
  static const mutualSystemStory = 'mutual-system/story';
  static const mutualSystemStories = 'mutual-system/stories';
  static const mutualSystemGlobalStory = 'mutual-system/story/global/';

  static const mutualSystemShare = 'mutual-system/share/';
  static const mutualSystemProfileLink = 'mutual-system/profile-link';

  static const popImages = 'account/pop-images/';

  static const globalFeed = 'account/feed/global/';
  static const userProfile = 'account/user';
  static const whoLikedMe = 'account/who-liked-me/';
  static const searchUsers = 'account/users/search/';
  static const filterUsers = 'account/users/filter/';

  static const notification = 'mutual-system/notifications/';

  static const privacyPolicy = 'privacy/privacy-policy/';
  static const termsAndConditions = 'privacy/terms-conditions/';

  static const threadList = 'chat/threads/';
  static const societyList = 'chat/societies/';
  static const createSociety = 'chat/societies/';
  static const createThreads = 'chat/threads/';
  static const revenueCatSubscriptionSync =
      'account/subscription/revenuecat-sync/';

  static const deleteAccount = 'account/profile/delete/';
}
