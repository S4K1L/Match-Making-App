import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/add_member_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),

          _customAppbar(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 130),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Today",
                      style: TextStyle(
                        color: Color(0xFF707270),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(12),
                      children: const [
                        ChatBubble(
                          isMe: false,
                          text: "Hi. Sarthak! How are you doing?",
                          showAvatar: true,
                        ),
                        ChatBubble(
                          isMe: true,
                          text: "Hi Shreya, I'm doing well. Thanks for asking!",
                        ),
                        ChatBubble(
                          isMe: true,
                          text: "What do you like to do for fun?",
                        ),
                        ChatBubble(
                          isMe: false,
                          text: "What do you like to do for fun?",
                          showAvatar: true,
                        ),
                        ChatBubble(
                          isMe: true,
                          text: "Hi Shreya, I'm doing well. Thanks for asking!",
                        ),
                      ],
                    ),
                  ),

                  // Bottom Input Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FDFF),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/emoji.svg'),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: TextField(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF666666),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Message",
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF707270),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SvgPicture.asset('assets/icons/camera.svg'),
                                const SizedBox(width: 12),
                                SvgPicture.asset('assets/icons/file.svg'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 44,
                          width: 44,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF18433B), Color(0xFF0C312B)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/send.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customAppbar() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF707270),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/amiliva.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ethan Carter",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),

                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 70,
                            child: Stack(
                              children: List.generate(4, (index) {
                                return Positioned(
                                  left: index * 16.0,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
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
                  const Spacer(),

                  SvgPicture.asset('assets/icons/mobile.svg'),

                  const SizedBox(width: 10),
                  PopupMenuButton(
                    color: const Color(0xFFFFFFFF),
                    onSelected: (value) {},
                    icon: Icon(Icons.more_vert, color: AppColors.textColor),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          onTap: () {
                            Get.to(() => AddMemberScreen());
                          },
                          value: 'Add people',
                          child: const Text(
                            'Add People',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final bool showAvatar;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.text,
    this.showAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      // Sender message (Right side, No avatar)
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF18433B), Color(0xFF0C312B)],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    } else {
      // Receiver message (Left side, With avatar optionally)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/olivia.png'),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            const SizedBox(width: 32), // placeholder for alignment

          const SizedBox(width: 8),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF707270),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
