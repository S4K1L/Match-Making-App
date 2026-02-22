import 'package:flutter/material.dart';
import 'package:flutter_extension/model/global_story_model.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/screen/Chat/chat_screen.dart';
import 'package:flutter_extension/views/screen/Profile/AllSubScreen/report_and_issue_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DetailsPage extends StatelessWidget {
  final GlobalStoryModel globalStoryModel;

  const DetailsPage({super.key, required this.globalStoryModel});

  @override
  Widget build(BuildContext context) {
    final user = globalStoryModel;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF2A2D2A),
                        ),
                      ),
                      const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2A2D2A),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF8FDFF),
                          border: Border.all(
                            color: const Color(0xFF2EAED2).withOpacity(0.2),
                            width: 0.3,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/notification.svg',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// PROFILE IMAGE
                        Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    (user.popImages != null &&
                                        user.popImages!.isNotEmpty)
                                    ? NetworkImage(
                                        user.popImages!.first.imageUrl ?? "",
                                      )
                                    : const AssetImage(
                                            'assets/images/placeholder.png',
                                          )
                                          as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// ONLINE STATUS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: user.isOnline == true
                                    ? const Color(0xFF00CD07)
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user.isOnline == true ? "Active" : "Offline",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2A2D2A),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// NAME
                        Text(
                          user.fullName ?? user.username ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          user.username ?? user.username ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// HOBBIES
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: (user.hobbies ?? [])
                              .map((e) => _tag(e))
                              .toList(),
                        ),

                        const SizedBox(height: 20),

                        _heading("My Bio"),
                        const SizedBox(height: 8),
                        _subText("No bio available"),

                        const SizedBox(height: 20),

                        _heading("Location"),
                        const SizedBox(height: 8),
                        _subText("Location not available"),

                        const SizedBox(height: 20),

                        _heading("Photos"),
                        const SizedBox(height: 10),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: user.popImages?.length ?? 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemBuilder: (context, index) {
                            final image = user.popImages?[index].imageUrl ?? "";

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: image.isNotEmpty
                                      ? NetworkImage(image)
                                      : const AssetImage(
                                              "assets/images/placeholder.png",
                                            )
                                            as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 30),

                        /// MESSAGE BUTTON
                        Center(
                          child: InkWell(
                            onTap: () => Get.to(() => const ChatScreen()),
                            child: Container(
                              height: 45,
                              width: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF18433B),
                                    Color(0xFF0C312B),
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/icons/message.svg"),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Message",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// ACTION BUTTONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _circleBtn(
                              Icons.close,
                              () => Get.back(),
                              color: Colors.white,
                            ),
                            const SizedBox(width: 20),
                            _circleBtn(Icons.favorite, () {}, gradient: true),
                          ],
                        ),

                        const SizedBox(height: 30),

                        _actionBtn("Block", () {}),
                        const SizedBox(height: 10),
                        _actionBtn("Report an Issue", () {
                          Get.to(() => const ReportAndIssueScreen());
                        }),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF18433B), Color(0xFF0C312B)],
        ),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: Colors.white)),
    );
  }

  Widget _heading(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  Widget _subText(String text) {
    return Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey));
  }

  Widget _circleBtn(
    IconData icon,
    VoidCallback onTap, {
    bool gradient = false,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gradient ? null : color ?? Colors.white,
          gradient: gradient
              ? const LinearGradient(
                  colors: [Color(0xFF18433B), Color(0xFF0C312B)],
                )
              : null,
        ),
        child: Icon(icon, color: gradient ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _actionBtn(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFFEBE1BF),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
