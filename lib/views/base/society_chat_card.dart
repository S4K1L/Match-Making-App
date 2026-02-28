import 'package:flutter/material.dart';
import 'package:flutter_extension/model/society_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/group_chat_screen.dart';
import 'package:get/get.dart';

class SocietyChatCard extends StatelessWidget {
  final SocietyModel societyModel;

  const SocietyChatCard({super.key, required this.societyModel});

  @override
  Widget build(BuildContext context) {
    final members = societyModel.fullMemberImages;

    return InkWell(
      onTap: () {
        Get.to(() => GroupChatScreen(societyModel: societyModel));
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: societyModel.image != null
                        ? NetworkImage(societyModel.fullImage)
                        : const AssetImage('assets/images/amiliva.png')
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (societyModel.name ?? "").toUpperCase(),
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
                          children: List.generate(
                            members.length > 4 ? 4 : members.length,
                            (index) {
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
                        _formatMemberCount(societyModel.memberCount),
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
            ],
          ),

          const Divider(color: Color(0xFF707270)),
        ],
      ),
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
