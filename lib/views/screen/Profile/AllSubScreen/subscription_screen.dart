import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/rev_cat_controller.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final RevCatController _rc = Get.find<RevCatController>();

  // ─── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _handlePurchase(String packageName) async {
    final info = await _rc.purchasePackage(
      packageName: packageName,
      offeringName: AppConstants.RC_OFFERING,
    );

    if (info != null && _rc.isSubscribed) {
      showCustomSnackBar('Subscription activated!', isError: false);
    } else if (_rc.lastError.value.isNotEmpty) {
      showCustomSnackBar(_rc.lastError.value, isError: true);
    }
  }

  Future<void> _handleShowPaywall() async {
    final result = await _rc.showPaywallIfNeeded();
    if (result.name == 'purchased' || result.name == 'restored') {
      showCustomSnackBar('Subscription activated!', isError: false);
    } else if (result.name == 'error' && _rc.lastError.value.isNotEmpty) {
      showCustomSnackBar(_rc.lastError.value, isError: true);
    }
  }

  Future<void> _handleRestore() async {
    final info = await _rc.restorePackage();
    if (info != null && _rc.isSubscribed) {
      showCustomSnackBar('Purchases restored!', isError: false);
    } else if (info != null && !_rc.isSubscribed) {
      showCustomSnackBar('No active purchases found.', isError: false);
    } else if (_rc.lastError.value.isNotEmpty) {
      showCustomSnackBar(_rc.lastError.value, isError: true);
    }
  }

  // ─── Widgets ───────────────────────────────────────────────────────────────

  Widget _buildFeatureLine(String text, bool allCaps) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Text(
              '• ',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF4A4A4A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              allCaps ? text.toUpperCase() : text,
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
    required String packageName,
    required String title,
    required Widget icon,
    required List<String> features,
    required bool isPremium,
    required bool isSolidButton,
    required double width,
    required double height,
    required bool allCaps,
  }) {
    return Obx(() {
      final isThisLoading = _rc.isPurchasing.value &&
          _rc.activePackageId.value == packageName;

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
                    .map((f) => _buildFeatureLine(f, allCaps))
                    .toList(),
              ),
            ),
            InkWell(
              onTap: isThisLoading ? null : () => _handlePurchase(packageName),
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
                      : Border.all(
                          color: const Color(0xFFD49E17), width: 1.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: isThisLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'SUBSCRIBE',
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
    });
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sideCardWidth = (screenWidth * 0.35).clamp(120.0, 140.0);
    final centerCardWidth = (screenWidth * 0.42).clamp(145.0, 165.0);

    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            // Background
            SizedBox.expand(
              child: Image.asset(Images.greeyBackground, fit: BoxFit.fill),
            ),

            SafeArea(
              child: Column(
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: Get.back,
                          child: const SizedBox(
                            width: 40,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.arrow_back_ios,
                                  color: Color(0xFF494949)),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'SUBSCRIPTION',
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

                  // ── Body ────────────────────────────────────────────────
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Active badge
                        if (_rc.isSubscribed)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              '${_rc.activeTierLabel ?? 'SUBSCRIPTION'} ACTIVE',
                              style: const TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF133F36),
                              ),
                            ),
                          ),

                        // ── Three plan cards ────────────────────────────
                        SizedBox(
                          height: 400,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // SOCIETY — left
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: _buildCard(
                                    packageName:
                                        AppConstants.RC_PACKAGE_SOCIETY,
                                    title:
                                        'SOCIETY ${_rc.priceLabelFor(AppConstants.RC_PACKAGE_SOCIETY)}',
                                    icon: SvgPicture.asset(
                                      'assets/icons/society.svg',
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFD49E17),
                                        BlendMode.srcIn,
                                      ),
                                      width: 38,
                                    ),
                                    isPremium: false,
                                    isSolidButton: true,
                                    width: sideCardWidth,
                                    height: 380,
                                    allCaps: true,
                                    features: [
                                      'Core Matching',
                                      'Limited Daily Likes',
                                      'Standard Swiping',
                                      'Basic Profile Filters',
                                      'One Profile Refresh a Month',
                                      'Weekly Boosts',
                                    ],
                                  ),
                                ),
                              ),

                              // ELITE — right
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: _buildCard(
                                    packageName:
                                        AppConstants.RC_PACKAGE_ELITE,
                                    title:
                                        'ELITE ${_rc.priceLabelFor(AppConstants.RC_PACKAGE_ELITE)}',
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
                                    width: sideCardWidth,
                                    height: 380,
                                    allCaps: true,
                                    features: [
                                      'Unlimited Likes & Matches',
                                      'Full Value & Lifestyle Filters',
                                      'All Society Room Access',
                                      'View "Who Liked You"',
                                      'Advance Matching',
                                      'Weekly Boosts',
                                    ],
                                  ),
                                ),
                              ),

                              // PREMIUM — center (featured)
                              Align(
                                alignment: Alignment.center,
                                child: _buildCard(
                                  packageName:
                                      AppConstants.RC_PACKAGE_PREMIUM,
                                  title:
                                      'PREMIUM ${_rc.priceLabelFor(AppConstants.RC_PACKAGE_PREMIUM)}',
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
                                  width: centerCardWidth,
                                  height: 380,
                                  allCaps: false,
                                  features: [
                                    'Unlimited Likes & Matches',
                                    'Full Values & Lifestyle Filters',
                                    'Access to All Society Rooms',
                                    'View "Who Liked You"',
                                    'Advanced Matching',
                                    'Premium Badge',
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // ── Subscribe Now button ─────────────────────────
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 40),
                          child: InkWell(
                            onTap: _handleShowPaywall,
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFF133F36),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'SUBSCRIBE NOW',
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

                        // ── Restore / Customer Center ────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: _rc.isRestoring.value
                                  ? null
                                  : _handleRestore,
                              child: _rc.isRestoring.value
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Text('Restore Purchases'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: _rc.isLoading.value
                                  ? null
                                  : _rc.openCustomerCenter,
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

            // Full-screen loading overlay (initial offerings fetch only)
            if (_rc.isLoading.value && _rc.offerings.value == null)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
