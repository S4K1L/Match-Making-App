import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/subscription_controller.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionController _subscriptionController =
      Get.find<SubscriptionController>();

  Future<void> _handlePurchase(String packageId) async {
    final success = await _subscriptionController.purchasePlan(packageId);
    if (success) {
      showCustomSnackBar('BLINK Pro activated.', isError: false);
      return;
    }
    showCustomSnackBar(
      _subscriptionController.lastError.value.isEmpty
          ? 'Purchase was not completed.'
          : _subscriptionController.lastError.value,
      isError: true,
    );
  }

  Future<void> _showPaywall() async {
    final result = await _subscriptionController.showPaywallIfNeeded();
    if (result.name == 'purchased' || result.name == 'restored') {
      showCustomSnackBar('BLINK Pro activated.', isError: false);
      return;
    }
    if (result.name == 'error') {
      showCustomSnackBar(
        _subscriptionController.lastError.value.isEmpty
            ? 'Unable to load paywall right now.'
            : _subscriptionController.lastError.value,
        isError: true,
      );
    }
  }

  Widget _buildFeatureLine(String text, bool isAllLargeCaps) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Text(
              "• ",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF4A4A4A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              isAllLargeCaps ? text.toUpperCase() : text,
              style: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 11,
                color: Color(0xFF4A4A4A),
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Widget icon,
    required List<String> features,
    required bool isPremium,
    required bool isSolidButton,
    required double width,
    required double height,
    required bool isAllLargeCaps,
    required VoidCallback onTap,
    bool? isLoading = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEBE1BF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isPremium ? 0.2 : 0.05),
            blurRadius: isPremium ? 25 : 10,
            spreadRadius: isPremium ? 2 : 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          SizedBox(height: 35, child: icon),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD49E17),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features
                  .map((f) => _buildFeatureLine(f, isAllLargeCaps))
                  .toList(),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              height: 38,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: isSolidButton
                    ? const LinearGradient(
                        colors: [Color(0xFFE9C54F), Color(0xFFD49E17)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                border: isSolidButton
                    ? null
                    : Border.all(color: const Color(0xFFD49E17), width: 1.5),
                borderRadius: BorderRadius.circular(25),
              ),
              alignment: Alignment.center,
              child: isLoading == true
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: const CircularProgressIndicator(),
                    )
                  : Text(
                      "SUBSCRIBE",
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: isSolidButton
                            ? Colors.white
                            : const Color(0xFFD49E17),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sideCardWidth = (screenWidth * 0.35).clamp(120.0, 140.0);
    double centerCardWidth = (screenWidth * 0.42).clamp(145.0, 165.0);

    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(Images.greeyBackground, fit: BoxFit.fill),
            ),
            SafeArea(
              child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const SizedBox(
                          width: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFF494949),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "SUBSCRIPTION",
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF133F36),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                  Expanded(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_subscriptionController.isBlinkProActive.value)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            "BLINK PRO ACTIVE",
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF133F36),
                            ),
                          ),
                        ),
                      // Subscription Cards Stack
                      SizedBox(
                        height: 400,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // SOCIETY
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: _buildCard(
                                  title:
                                      "WEEKLY ${_subscriptionController.priceLabelFor(ApiConstant.REVENUECAT_PACKAGE_WEEKLY)}",
                                  icon: SvgPicture.asset(
                                    'assets/icons/society.svg',
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFD49E17),
                                      BlendMode.srcIn,
                                    ),
                                    width: 38,
                                  ),
                                  isPremium: false,
                                  isLoading:
                                      _subscriptionController.isPurchasing.value &&
                                          _subscriptionController
                                                  .activePackageId.value ==
                                              ApiConstant.REVENUECAT_PACKAGE_WEEKLY,
                                  isSolidButton: true,
                                  width: sideCardWidth,
                                  height: 380,
                                  isAllLargeCaps: true,

                                  onTap: () {
                                    _handlePurchase(
                                      ApiConstant.REVENUECAT_PACKAGE_WEEKLY,
                                    );
                                  },
                                  features: [
                                    "Core Matching",
                                    "Limited Daily Likes",
                                    "Standard Swiping",
                                    "Basic Profile Filters",
                                    "One Profile Refresh a Month",
                                    "Weekly Boosts",
                                  ],
                                ),
                              ),
                            ),

                            // ELITE
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: _buildCard(
                                  title:
                                      "MONTHLY ${_subscriptionController.priceLabelFor(ApiConstant.REVENUECAT_PACKAGE_MONTHLY)}",
                                  icon: SvgPicture.asset(
                                    'assets/icons/elite.svg',
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFD49E17),
                                      BlendMode.srcIn,
                                    ),
                                    width: 38,
                                  ),
                                  isPremium: false,
                                  isSolidButton: true,
                                  isLoading:
                                      _subscriptionController.isPurchasing.value &&
                                          _subscriptionController
                                                  .activePackageId.value ==
                                              ApiConstant.REVENUECAT_PACKAGE_MONTHLY,
                                  width: sideCardWidth,
                                  height: 380,
                                  isAllLargeCaps: true,
                                  onTap: () {
                                    _handlePurchase(
                                      ApiConstant.REVENUECAT_PACKAGE_MONTHLY,
                                    );
                                  },
                                  features: [
                                    "Unlimited Likes & Matches",
                                    "Full Value & Lifestyle Filters",
                                    "All Society Room Access",
                                    "View “Who Liked You”",
                                    "Advance Matching",
                                    "Weekly Boosts",
                                  ],
                                ),
                              ),
                            ),

                            // PREMIUM
                            Align(
                              alignment: Alignment.center,
                              child: _buildCard(
                                title:
                                    "YEARLY ${_subscriptionController.priceLabelFor(ApiConstant.REVENUECAT_PACKAGE_YEARLY)}",
                                icon: SvgPicture.asset(
                                  'assets/icons/crown.svg',
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFD49E17),
                                    BlendMode.srcIn,
                                  ),
                                  width: 38,
                                ),
                                isPremium: true,
                                isSolidButton: true,
                                isLoading:
                                    _subscriptionController.isPurchasing.value &&
                                        _subscriptionController
                                                .activePackageId.value ==
                                            ApiConstant.REVENUECAT_PACKAGE_YEARLY,
                                width: centerCardWidth,
                                height: 380,
                                isAllLargeCaps: false,
                                onTap: () {
                                  _handlePurchase(
                                    ApiConstant.REVENUECAT_PACKAGE_YEARLY,
                                  );
                                },
                                features: [
                                  "Unlimited Likes & Matches",
                                  "Full Values & Lifestyle Filters",
                                  "Access to All Society Rooms",
                                  "View “Who Liked You”",
                                  "Advanced Matching",
                                  "Premium Badge",
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      // SUBSCRIBE NOW Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: InkWell(
                          onTap: () {
                            _showPaywall();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF133F36), // Deep green
                              borderRadius: BorderRadius.circular(35),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "SUBSCRIBE NOW",
                              style: TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _subscriptionController.isLoading.value
                                ? null
                                : _subscriptionController.restore,
                            child: const Text('Restore Purchases'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _subscriptionController.isLoading.value
                                ? null
                                : _subscriptionController.openCustomerCenter,
                            child: const Text('Customer Center'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            ),
            if (_subscriptionController.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
