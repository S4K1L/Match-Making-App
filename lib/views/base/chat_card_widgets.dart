import 'package:flutter/material.dart';
import 'package:flutter_extension/model/chat_model.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/screen/Chat/inbox.dart';
import 'package:get/get.dart';

class ChatCardWidgets extends StatelessWidget {
  final ChatThreadModel chat;

  const ChatCardWidgets({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final user = chat.otherUser;
    final message = chat.lastMessage;

    return InkWell(
      onTap: () {
        Get.to(() => InboxScreen(threadId: chat.threadId));
      },
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: user?.profilePic != null
                    ? NetworkImage(_fullImage(user!.profilePic!))
                    : const AssetImage('assets/images/olivia.png')
                          as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.fullName ?? "Unknown",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  message?.content ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF4F595E),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(message?.createdAt),
                style: const TextStyle(
                  color: Color(0xFF4F595E),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              //TODO: add unread count
              if (!(message?.isRead ?? true))
                Container(
                  height: 16,
                  width: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF18433B), Color(0xFF0C312B)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _fullImage(String path) {
    if (path.startsWith("http")) return path;
    return ApiConstant.BASE_URL_IMAGE + path;
  }

  String _formatTime(DateTime? time) {
    if (time == null) return "";

    final diff = DateTime.now().difference(time);

    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${diff.inDays}d";
  }
}
