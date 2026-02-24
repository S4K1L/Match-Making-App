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
    final unreadCount = chat.unreadCount;

    return InkWell(
      onTap: () {
        Get.to(() => InboxScreen(chatModel: chat));
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
              if (unreadCount > 0) ...[
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
                        unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
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

    final now = DateTime.now();

    final isToday =
        now.year == time.year && now.month == time.month && now.day == time.day;

    final yesterday = now.subtract(const Duration(days: 1));

    final isYesterday =
        yesterday.year == time.year &&
        yesterday.month == time.month &&
        yesterday.day == time.day;

    if (isToday) {
      return _formatToAmPm(time);
    }

    if (isYesterday) {
      return "Yesterday";
    }

    return _formatDate(time);
  }

  String _formatToAmPm(DateTime time) {
    int hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "$hour:$minute $period";
  }

  String _formatDate(DateTime time) {
    return "${time.day}/${time.month}/${time.year}";
  }
}
