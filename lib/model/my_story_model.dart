import 'package:flutter_extension/util/api_constant.dart';

class MyStoryModel {
  final String id;
  final String user;
  final int userId;
  final String userFullName;

  final String? text;
  final String? media;

  final int viewCount;
  final int likesCount;
  final bool isLiked;

  final DateTime createdAt;
  final DateTime expiresAt;

  MyStoryModel({
    required this.id,
    required this.user,
    required this.userId,
    required this.userFullName,
    this.text,
    this.media,
    required this.viewCount,
    required this.likesCount,
    required this.isLiked,
    required this.createdAt,
    required this.expiresAt,
  });

  factory MyStoryModel.fromJson(Map<String, dynamic> json) {
    final rawMedia = json['media'];

    String? fullMedia;
    if (rawMedia != null && rawMedia.toString().isNotEmpty) {
      if (rawMedia.startsWith('http')) {
        fullMedia = rawMedia;
      } else {
        fullMedia = ApiConstant.BASE_URL_IMAGE + rawMedia;
      }
    }

    return MyStoryModel(
      id: json['id'] ?? '',
      user: json['user'] ?? '',
      userId: json['user_id'] ?? 0,
      userFullName: json['user_full_name'] ?? '',

      text: json['text'],
      media: fullMedia,

      viewCount: json['view_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,

      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'user_id': userId,
      'user_full_name': userFullName,
      'text': text,
      'media': media,
      'view_count': viewCount,
      'likes_count': likesCount,
      'is_liked': isLiked,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
