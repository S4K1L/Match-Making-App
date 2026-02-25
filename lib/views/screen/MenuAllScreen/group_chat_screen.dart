import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/society_controller.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/model/society_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/society_chat_bubble.dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/add_member_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GroupChatScreen extends StatefulWidget {
  final SocietyModel societyModel;
  const GroupChatScreen({super.key, required this.societyModel});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final SocietyController controller = Get.put(SocietyController());

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  bool showEmoji = false;
  late int societyId;

  @override
  void initState() {
    super.initState();

    societyId = widget.societyModel.id!;
    controller.initSocietyChat(societyId);

    ever(controller.societyChats, (_) => _scrollToBottom());

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() => showEmoji = false);
      }
    });
  }

  @override
  void dispose() {
    controller.disposeSocietyChat();
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    controller.sendSocietyMessage(text);
    messageController.clear();
  }

  void _pickCamera() {
    controller.sendSocietyImageMessage(societyId, source: ImageSource.camera);
  }

  void _pickGallery() {
    controller.sendSocietyImageMessage(societyId, source: ImageSource.gallery);
  }

  void _toggleEmoji() {
    setState(() => showEmoji = !showEmoji);

    if (showEmoji) {
      focusNode.unfocus();
    } else {
      FocusScope.of(context).requestFocus(focusNode);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _background(),
          _customAppbar(widget.societyModel),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 130),
              child: Column(
                children: [
                  Expanded(child: _messageList()),
                  _inputField(),
                  if (showEmoji) _emojiPicker(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return SizedBox.expand(
      child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
    );
  }

  Widget _messageList() {
    return Obx(() {
      final messages = controller.societyChats;
      final myId = Get.find<UserController>().userInfo.value!.userId;

      if (controller.isLoading.value && messages.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (_, i) {
          final msg = messages[i];
          final isMe = msg.sender?.userId == myId;

          return SocietyChatBubble(
            isMe: isMe,
            text: msg.content,
            attachment: msg.attachment,
            isUploading: msg.isUploading,
            showAvatar: !isMe,
            userProfile: msg.sender?.profilePic ?? "",
          );
        },
      );
    });
  }

  Widget _inputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _inputBox()),
          const SizedBox(width: 12),
          _sendButton(),
        ],
      ),
    );
  }

  Widget _inputBox() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FDFF),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggleEmoji,
            child: SvgPicture.asset('assets/icons/emoji.svg'),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: messageController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: "Message",
                border: InputBorder.none,
              ),
            ),
          ),

          GestureDetector(
            onTap: _pickCamera,
            child: SvgPicture.asset(
              'assets/icons/camera.svg',
              height: 28,
              width: 28,
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: _pickGallery,
            child: SvgPicture.asset(
              'assets/icons/file.svg',
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sendButton() {
    return GestureDetector(
      onTap: _sendMessage,
      child: Container(
        height: 44,
        width: 44,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF18433B), Color(0xFF0C312B)],
          ),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset('assets/icons/send.svg'),
        ),
      ),
    );
  }

  Widget _emojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          final text = messageController.text;
          final selection = messageController.selection;

          final newText = text.replaceRange(
            selection.start >= 0 ? selection.start : text.length,
            selection.end >= 0 ? selection.end : text.length,
            emoji.emoji,
          );

          messageController.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(
              offset:
                  (selection.start >= 0 ? selection.start : text.length) +
                  emoji.emoji.length,
            ),
          );

          setState(() {});
        },
      ),
    );
  }

  Widget _customAppbar(SocietyModel societyModel) {
    final members = societyModel.fullMemberImages;

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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: societyModel.image != null
                            ? NetworkImage(societyModel.fullImage)
                            : AssetImage('assets/images/amiliva.png'),
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
                        societyModel.name.toString(),
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
                              children: List.generate(
                                members.length > 4 ? 4 : members.length,
                                (index) {
                                  //TODO: member picture not found - backend issue
                                  return Positioned(
                                    left: index * 16.0,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 11,
                                        backgroundImage: NetworkImage(
                                          members[index],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            _formatMemberCount(widget.societyModel.memberCount),
                            style: const TextStyle(
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
                            //TODO: get people list api missing
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

  String _formatMemberCount(int? count) {
    if (count == null) return "0";

    if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(1)}M PEOPLE";
    } else if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}K PEOPLE";
    } else {
      return "$count PEOPLE";
    }
  }
}
