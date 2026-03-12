import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/calling_controller.dart';
import 'package:flutter_extension/controller/chat_controller.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/model/chat_model.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/chat_shimmer.dart';
import 'package:flutter_extension/views/screen/Chat/calling_screen.dart';
import 'package:flutter_extension/views/screen/Profile/AllSubScreen/report_and_issue_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base/chat_bubble.dart';

class InboxScreen extends StatefulWidget {
  final ChatThreadModel chatModel;

  const InboxScreen({super.key, required this.chatModel});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final ChatController _chatController = Get.find<ChatController>();

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _showEmoji = false;
  late int threadId;

  @override
  void initState() {
    super.initState();

    threadId = widget.chatModel.threadId;
    _chatController.initChat(threadId);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() => _showEmoji = false);
      }
    });
  }

  @override
  void dispose() {
    _chatController.disposeChat();
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    _chatController.sendTextMessage(threadId, text);

    _messageController.clear();

    setState(() {});

    _scrollToBottom();
  }

  void _toggleEmoji() {
    setState(() => _showEmoji = !_showEmoji);

    if (_showEmoji) {
      _focusNode.unfocus();
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  void _cameraSendImage() {
    _chatController.sendImageMessage(threadId, source: ImageSource.gallery);
  }

  void _gallerySendImage() {
    _chatController.sendImageMessage(threadId, source: ImageSource.camera);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
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
          _customAppbar(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 75),
              child: Column(
                children: [
                  // _dateChip(),
                  Expanded(child: _messageList()),
                  _inputField(),
                  if (_showEmoji) _emojiPicker(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI PARTS =================

  Widget _background() {
    return SizedBox.expand(
      child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
    );
  }

  Widget _emojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          final controller = _messageController;

          final text = controller.text;
          final selection = controller.selection;

          final newText = text.replaceRange(
            selection.start >= 0 ? selection.start : text.length,
            selection.end >= 0 ? selection.end : text.length,
            emoji.emoji,
          );

          controller.value = TextEditingValue(
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

  // Widget _dateChip() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 8),
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: const Text(
  //       "Today",
  //       style: TextStyle(fontSize: 12, color: Color(0xFF707270)),
  //     ),
  //   );
  // }

  Widget _messageList() {
    return Obx(() {
      final messages = _chatController.messageList;
      final myId = Get.find<UserController>().userInfo.value!.userId;

      if (_chatController.isLoading.value && messages.isEmpty) {
        return const ChatShimmer();
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (_, i) {
          final msg = messages[i];
          final isMe = msg.sender?.userId == myId;

          return ChatBubble(
            isMe: isMe,
            text: msg.content ?? "",
            attachment: msg.attachment,
            localPath: msg.localPath,
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
              controller: _messageController,
              focusNode: _focusNode,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: "Message",
                border: InputBorder.none,
              ),
            ),
          ),

          GestureDetector(
            onTap: _gallerySendImage,
            child: SvgPicture.asset(
              'assets/icons/camera.svg',
              height: 28,
              width: 28,
            ),
          ),

          const SizedBox(width: 12),
          GestureDetector(
            onTap: _cameraSendImage,
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

  // ================= APPBAR =================

  Widget _customAppbar() {
    final user = widget.chatModel.otherUser;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          child: Row(
            children: [
              InkWell(onTap: Get.back, child: const Icon(Icons.arrow_back_ios)),
              _avatar(user),
              const SizedBox(width: 12),
              _userInfo(user),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => CallingScreen(
                      receiverId: user!.userId.toString(),
                      image: ApiConstant.BASE_URL_IMAGE + user.profilePic!,
                      name: user.fullName!,
                      type: CallType.audio,
                    ),
                  );
                },
                child: SvgPicture.asset('assets/icons/mobile.svg'),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => CallingScreen(
                      receiverId: user!.userId.toString(),
                      image: ApiConstant.BASE_URL_IMAGE + user.profilePic!,
                      name: user.fullName!,
                      type: CallType.video,
                    ),
                  );
                },
                child: Icon(
                  Icons.video_call_outlined,
                  size: 28,
                  color: Colors.grey.shade700,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: () {
                      Get.to(
                        () => ReportAndIssueScreen(id: user!.userId.toString()),
                      );
                    },
                    value: 'report',
                    child: const Text('Report profile'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatar(user) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: user?.profilePic != null
              ? NetworkImage(_fullImage(user!.profilePic!))
              : const AssetImage('assets/images/olivia.png') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _userInfo(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(user!.fullName, style: TextStyle(color: AppColors.textColor)),
        Row(
          children: [
            CircleAvatar(radius: 4, backgroundColor: Colors.greenAccent),
            const SizedBox(width: 4),
            const Text("Active", style: TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }

  String _fullImage(String path) {
    if (path.startsWith("http")) return path;
    return ApiConstant.BASE_URL_IMAGE + path;
  }
}
