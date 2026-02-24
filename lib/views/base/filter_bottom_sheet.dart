import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/like_you_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:get/get.dart';

class FilterBottomSheet extends StatelessWidget {
  final LikeYouController likeYouController;

  const FilterBottomSheet(
    BuildContext context, {
    super.key,
    required this.likeYouController,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),

      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.7,

        child: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
            ),

            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

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

                    _sectionTitle("Gender"),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _genderOption("Male"),
                        _genderOption("Female"),
                        _genderOption("Other"),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle("Distance"),

                    const SizedBox(height: 40),

                    Obx(
                      () => Slider(
                        value: likeYouController.distance.value > 1000
                            ? 1000
                            : likeYouController.distance.value,
                        min: 1,
                        max: 1000,
                        divisions: 1000,
                        label: likeYouController.distance.value > 1000
                            ? "Unlimited"
                            : "${likeYouController.distance.value.round()} km",
                        onChanged: (val) {
                          if (val == 1000) {
                            likeYouController.distance.value = double.infinity;
                          } else {
                            likeYouController.distance.value = val;
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle("Age"),

                    const SizedBox(height: 40),

                    Obx(() {
                      final v = likeYouController.rv.value;

                      return LayoutBuilder(
                        builder: (ctx, cons) {
                          const pad = 12.0;
                          final w = cons.maxWidth - pad * 2;

                          double t(double x) =>
                              ((x - likeYouController.min) /
                                      (likeYouController.max -
                                          likeYouController.min))
                                  .clamp(0, 1);

                          final x1 = pad + w * t(v.start);
                          final x2 = pad + w * t(v.end);

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(ctx).copyWith(
                                  trackHeight: 4,
                                  inactiveTrackColor: const Color(0xFFE0E0E0),
                                  activeTrackColor: const Color(0xFF0C312B),
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 10,
                                  ),
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),
                                child: RangeSlider(
                                  min: likeYouController.min,
                                  max: likeYouController.max,
                                  values: v,
                                  onChanged: (nv) =>
                                      likeYouController.rv.value = nv,
                                ),
                              ),

                              Positioned(
                                top: -40,
                                left: x1 - 18,
                                child: _Bubble(
                                  text: v.start.toStringAsFixed(0),
                                ),
                              ),

                              Positioned(
                                top: -40,
                                left: x2 - 18,
                                child: _Bubble(text: v.end.toStringAsFixed(0)),
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
                          child: GestureDetector(
                            onTap: () {
                              likeYouController.resetFilters();
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: Obx(
                            () => CustomButton(
                              loading: likeYouController.isLoading.value,
                              onTap: () {
                                likeYouController.filterUser();
                              },
                              text: "Apply",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  InkWell _genderOption(String gender) {
    return InkWell(
      onTap: () {
        likeYouController.selectedGender.value = gender;
      },
      child: Obx(
        () => Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 35),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: likeYouController.selectedGender.value == gender
                ? const Color(0xFF0C312B)
                : const Color(0xFFFFFFFF),
          ),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(
                color: likeYouController.selectedGender.value == gender
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
