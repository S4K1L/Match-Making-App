import 'package:flutter_extension/util/api_constant.dart';

class MutualStoryModel {
  final String id;
  final int userId;
  final String? fullName;
  final String? text;
  final String? media;
  final String? profilePic;
  final int viewCount;
  final int likesCount;
  final bool isLiked;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  MutualStoryModel({
    required this.id,
    required this.userId,
    this.fullName,
    this.text,
    this.media,
    this.profilePic,
    required this.viewCount,
    required this.likesCount,
    required this.isLiked,
    this.createdAt,
    this.expiresAt,
  });

  factory MutualStoryModel.fromJson(Map<String, dynamic> json) {
    return MutualStoryModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? 0,
      fullName: json['full_name'], // ✅ fixed
      text: json['text'],
      media: json['media'],
      profilePic: json['profile_pic'], // ✅ added
      viewCount: json['view_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
    );
  }

  /// Full media URL
  String? get fullMediaUrl {
    if (media == null || media!.isEmpty) return null;
    return "${ApiConstant.BASE_URL_IMAGE}$media";
  }

  /// Full profile image URL
  String? get fullProfilePicUrl {
    if (profilePic == null || profilePic!.isEmpty) return null;
    return "${ApiConstant.BASE_URL_IMAGE}$profilePic";
  }
}
