import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/matches_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/bottom_menu..dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/Notification/notification_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MatcheScreen extends StatefulWidget {
  const MatcheScreen({super.key});

  @override
  State<MatcheScreen> createState() => _MatcheScreenState();
}

class _MatcheScreenState extends State<MatcheScreen> {
  final _matchesController = Get.put(MatchesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                _customAppbar(),
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          filColor: const Color(0xFFFFFFFF),
                          filled: true,
                          hintText: "Search",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SvgPicture.asset('assets/icons/search.svg'),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2EAED2,
                              ).withValues(alpha: 0.20),
                              blurRadius: 2,
                              spreadRadius: 1.5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Color(0xFF707270),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: 6,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: .8,
                        ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/amiliva.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          const Positioned(
                            bottom: 5,
                            left: 10,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Color(0xFF00CD07),
                                      size: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Active",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Ethan Cruz",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      "1.0 km",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomMenu(1),
    );
  }

  Widget _customAppbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Image.asset(Images.appLogo, width: 52, height: 42),

          const Spacer(),

          InkWell(
            onTap: () {
              Get.to(() => const NotificationScreen());
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF8FDFF),
                border: Border.all(
                  color: const Color(0xFF2EAED2).withValues(alpha: 0.20),
                  width: 0.3,
                ),
              ),

              child: Center(
                child: SvgPicture.asset('assets/icons/notification.svg'),
              ),
            ),
          ),

          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              _showFilterBottomSheet(context);
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF8FDFF),
                border: Border.all(
                  color: const Color(0xFF2EAED2).withValues(alpha: 0.20),
                  width: 0.3,
                ),
              ),

              child: Center(child: SvgPicture.asset('assets/icons/filter.svg')),
            ),
          ),
        ],
      ),
    );
  }

  _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
            ),

            InkWell(
              onTap: () {},
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Filter",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Gender",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _genderOption("Male"),
                          _genderOption("Female"),
                          _genderOption("Other"),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Distance",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 62),

                      Obx(() {
                        final v = _matchesController
                            .value
                            .value; // current slider value
                        final w = MediaQuery.of(context).size.width - 40;
                        final left = (w * (v / 200) - 25).clamp(0.0, w - 50);

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Slider(
                              min: 0,
                              max: 200,
                              value: v,
                              activeColor: const Color(0xFF0C312B),
                              inactiveColor: const Color(0xFFE0E0E0),
                              onChanged: (val) =>
                                  _matchesController.value.value =
                                      val, // update Rx value
                            ),
                            Positioned(
                              top: -35,
                              left: left,
                              child: _Bubble(
                                text: "${v.toStringAsFixed(0)} km",
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 24),
                      Text(
                        "Age",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Obx(() {
                        final v = _matchesController.rv.value;

                        return LayoutBuilder(
                          builder: (ctx, cons) {
                            const pad = 12.0; // thumb padding
                            final w = cons.maxWidth - pad * 2;

                            double t(double x) =>
                                ((x - _matchesController.min) /
                                        (_matchesController.max -
                                            _matchesController.min))
                                    .clamp(0, 1);
                            final x1 = pad + w * t(v.start);
                            final x2 = pad + w * t(v.end);

                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // RangeSlider
                                SliderTheme(
                                  data: SliderTheme.of(ctx).copyWith(
                                    trackHeight: 4,
                                    inactiveTrackColor: const Color(0xFFE0E0E0),
                                    activeTrackColor: const Color(0xFF0C312B),
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 10,
                                    ),
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                    rangeTrackShape:
                                        const RoundedRectRangeSliderTrackShape(),
                                  ),
                                  child: RangeSlider(
                                    min: _matchesController.min,
                                    max: _matchesController.max,
                                    values: v,
                                    onChanged: (nv) =>
                                        _matchesController.rv.value = nv,
                                  ),
                                ),

                                // Start bubble
                                Positioned(
                                  top: -40,
                                  left: x1 - 18,
                                  child: _Bubble(
                                    text: v.start.toStringAsFixed(0),
                                  ),
                                ),

                                // End bubble
                                Positioned(
                                  top: -40,
                                  left: x2 - 18,
                                  child: _Bubble(
                                    text: v.end.toStringAsFixed(0),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                      const SizedBox(height: 42),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(38),
                              ),
                              child: Center(
                                child: Text(
                                  "Reset",
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: CustomButton(onTap: () {}, text: "Apply"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function for gender option widget
  _genderOption(String gender) {
    return InkWell(
      onTap: () {
        _matchesController.selectedGender.value = gender;
      },
      child: Obx(
        () => Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _matchesController.selectedGender.value == gender
                ? const Color(0xFF0C312B)
                : const Color(0xFFFFFFFF),
          ),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(
                color: _matchesController.selectedGender.value == gender
                    ? Colors.white
                    : const Color(0xFF707270),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
        ),
        CustomPaint(size: const Size(12, 6), painter: _TipPainter()),
      ],
    );
  }
}

class _TipPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(s.width / 2, s.height)
      ..lineTo(s.width, 0)
      ..close();
    c.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
