import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/bottom_menu..dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/group_chat_screen.dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/new_community_screen.dart';
import 'package:get/get.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _customAppbar(),
                  const SizedBox(height: 40),

                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => GroupChatScreen());
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/amiliva.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "MY JOIN COMMUNITY",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                          color: AppColors.textColor,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                            width: 70,
                                            child: Stack(
                                              children: List.generate(4, (
                                                index,
                                              ) {
                                                return Positioned(
                                                  left: index * 16.0,
                                                  child: CircleAvatar(
                                                    radius: 12,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 11,
                                                      backgroundImage: AssetImage(
                                                        'assets/images/amiliva.png',
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          Text(
                                            "1.5K PEOPLE",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF001C13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(color: Color(0xFF707270)),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 16),
                      itemCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: InkWell(
        onTap: () {
          Get.to(() => NewCommunityScreen());
        },
        child: Container(
          width: 200,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFC97E6D).withAlpha(10),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Color(0xFF234F38)),
              SizedBox(width: 5),
              Text(
                "Create Community",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF234F38),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomMenu(4),
    );
  }

  Widget _customAppbar() {
    return Center(
      child: Text(
        "Community ",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}
