import 'package:flutter/material.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/screen/Chat/chat_screen.dart';
import 'package:flutter_extension/views/screen/Profile/AllSubScreen/report_and_issue_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
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

                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF8FDFF),
                            border: Border.all(
                              color: const Color(
                                0xFF2EAED2,
                              ).withValues(alpha: 0.20),
                              width: 0.3,
                            ),
                          ),

                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/notification.svg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/olivia.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF00CD07),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Active",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2A2D2A),
                              ),
                            ),
                          ],
                        ),

                        const Text(
                          "Jhon Mandela",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Text(
                              "26 Age",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF707270),
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF707270),
                            ),
                            SizedBox(width: 2),
                            Text(
                              "0.6 km",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF707270),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _customContainer(
                              backgroundColor: const Color(0xFFFFFFFF),
                              image: 'assets/images/m.png',
                              text: 'R&B',
                              textColor: const Color(0xFFFFFFFF),
                            ),
                            const SizedBox(width: 12),
                            _customContainer(
                              backgroundColor: const Color(0xFFFF5B77),
                              image: 'assets/images/a.png',
                              text: 'Gardening',
                              textColor: const Color(0xFFFF4F6D),
                            ),
                            const SizedBox(width: 12),
                            _customContainer(
                              backgroundColor: const Color(0xFF00E6D6),
                              image: 'assets/images/g.png',
                              text: 'Vegetarian',
                              textColor: const Color(0xFF009994),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _customContainer(
                              backgroundColor: const Color(0xFF02C5A2),
                              image: 'assets/images/g.png',
                              text: 'Dogs',
                              textColor: const Color(0xFF00BFA9),
                            ),
                            const SizedBox(width: 12),
                            _customContainer(
                              backgroundColor: const Color(0xFFE500FF),
                              image: 'assets/images/a.png',
                              text: 'Dancing',
                              textColor: const Color(0xFFAD00DA),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        _headingText(text: "My Bio"),
                        const SizedBox(height: 8),
                        _subText(
                          subTitle:
                              "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley.",
                        ),
                        const SizedBox(height: 16),
                        _headingText(text: "Location"),
                        const SizedBox(height: 8),

                        _subText(
                          subTitle: "42 Elmwood Crescent, United Kingdom",
                        ),

                        const SizedBox(height: 16),
                        _headingText(text: "I’m looking for"),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildContainer(text: 'A long- term relationship'),
                            const SizedBox(width: 12),
                            _buildContainer(text: 'A life partner'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildContainer(text: 'Fun, casual dates'),
                            const SizedBox(width: 12),
                            _buildContainer(text: 'Marriage'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _headingText(text: "Photo"),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/amiliva.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => const ChatScreen());
                            },
                            child: Container(
                              height: 40,
                              width: 113,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45),
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
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 78,
                                width: 78,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,

                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF000000,
                                      ).withValues(alpha: 0.07),
                                      blurRadius: 50,

                                      offset: const Offset(0, 20),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xFF0C312B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            Container(
                              height: 78,
                              width: 78,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF18433B),
                                    Color(0xFF0C312B),
                                  ],
                                ),
                                shape: BoxShape.circle,

                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF676767,
                                    ).withValues(alpha: 0.20),
                                    blurRadius: 15,

                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Color(0xFFFFFFFF),
                                size: 35,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        _customButton(text: "Block", onTap: () {}),
                        const SizedBox(height: 8),
                        _customButton(
                          text: "Report an Issue",
                          onTap: () {
                            Get.to(() => const ReportAndIssueScreen());
                          },
                        ),
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

  _customContainer({
    required Color backgroundColor,
    required String image,
    required String text,
    required Color textColor,
  }) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF18433B), Color(0xFF0C312B)],
        ),
      ),
      child: Row(
        children: [
          Image.asset(image, height: 10, width: 10),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  _buildContainer({required String text}) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF707270), width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4F595E),
        ),
      ),
    );
  }

  _subText({required String subTitle}) {
    return Text(
      subTitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF707270),
      ),
    );
  }

  _headingText({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  _customButton({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEBE1BF),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFF6C53E), width: 1),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF2A2D2A),
            ),
          ),
        ),
      ),
    );
  }
}
