import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/like_you_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/filter_bottom_sheet.dart';
import 'package:flutter_extension/views/base/like_card.dart';
import 'package:flutter_extension/views/base/search_text_field.dart';
import 'package:flutter_extension/views/screen/Notification/notification_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MatcheScreen extends StatefulWidget {
  const MatcheScreen({super.key});

  @override
  State<MatcheScreen> createState() => _MatcheScreenState();
}

class _MatcheScreenState extends State<MatcheScreen> {
  final LikeYouController likeYouController = Get.put(LikeYouController());

  @override
  void initState() {
    likeYouController.getAllLikeYou();
    super.initState();
  }

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
                        child: SearchTextField(
                          hintText: "Search",
                          controller: likeYouController.searchController,
                          onChanged: likeYouController.onSearchChanged,
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
                  child: Obx(() {
                    if (likeYouController.isLoading.value) {
                      return _shimmerGrid();
                    }

                    final list = likeYouController.likeYouList;

                    if (list.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }

                    return RefreshIndicator(
                      onRefresh: likeYouController.getAllLikeYou,
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: list.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: .8,
                            ),
                        itemBuilder: (context, index) {
                          final user = list[index];

                          final image = user.profilePic?.isNotEmpty == true
                              ? user.profilePic ?? ""
                              : "";

                          return LikeCard(image: image, user: user);
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
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
            onTap: () => showFilterBottomSheet(context),
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

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          FilterBottomSheet(context, likeYouController: likeYouController),
    );
  }

  Widget _shimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: .8,
      ),
      itemBuilder: (_, _) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade300,
          ),
        );
      },
    );
  }
}
