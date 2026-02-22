import 'package:flutter_extension/util/api_constant.dart';

class MutualStoryModel {
  final String id;
  final String? user;
  final String? text;
  final String? media;
  final int viewCount;
  final int likesCount;
  final bool isLiked;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  MutualStoryModel({
    required this.id,
    this.user,
    this.text,
    this.media,
    required this.viewCount,
    required this.likesCount,
    required this.isLiked,
    this.createdAt,
    this.expiresAt,
  });

  factory MutualStoryModel.fromJson(Map<String, dynamic> json) {
    return MutualStoryModel(
      id: json['id'] ?? '',
      user: json['user'],
      text: json['text'],
      media: json['media'],
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

  String? get fullMediaUrl {
    if (media == null || media!.isEmpty) return null;
    return "${ApiConstant.BASE_URL_IMAGE}$media";
    // return "$media";
  }
}
