import 'package:flutter_extension/util/api_constant.dart';

class MyStoryModel {
  final String id;

  final String? text;
  final String? media;

  final int viewCount;
  final int totalViews;

  final DateTime createdAt;
  final DateTime expiresAt;

  final List<StoryViewerModel> viewers;

  MyStoryModel({
    required this.id,
    this.text,
    this.media,
    required this.viewCount,
    required this.totalViews,
    required this.createdAt,
    required this.expiresAt,
    required this.viewers,
  });

  factory MyStoryModel.fromJson(Map<String, dynamic> json) {
    final rawMedia = json['media'];

    String? fullMedia;
    if (rawMedia != null && rawMedia.toString().isNotEmpty) {
      if (rawMedia.toString().startsWith('http')) {
        fullMedia = rawMedia;
      } else {
        fullMedia = ApiConstant.BASE_URL_IMAGE + rawMedia;
      }
    }

    return MyStoryModel(
      id: json['id'] ?? '',

      text: json['text'],
      media: fullMedia,

      viewCount: json['view_count'] ?? 0,
      totalViews: json['total_views'] ?? 0,

      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),

      viewers: (json['viewers'] as List? ?? [])
          .map((e) => StoryViewerModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'media': media,
      'view_count': viewCount,
      'total_views': totalViews,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'viewers': viewers.map((e) => e.toJson()).toList(),
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class StoryViewerModel {
  final int userId;
  final String fullName;
  final String? profilePic;
  final double? distance;

  StoryViewerModel({
    required this.userId,
    required this.fullName,
    this.profilePic,
    this.distance,
  });

  factory StoryViewerModel.fromJson(Map<String, dynamic> json) {
    String? fullProfile;

    if (json['profile_pic'] != null &&
        json['profile_pic'].toString().isNotEmpty) {
      if (json['profile_pic'].toString().startsWith('http')) {
        fullProfile = json['profile_pic'];
      } else {
        fullProfile = ApiConstant.BASE_URL_IMAGE + json['profile_pic'];
      }
    }

    return StoryViewerModel(
      userId: json['user_id'] ?? 0,
      fullName: json['full_name'] ?? '',
      profilePic: fullProfile,
      distance: (json['distance'] != null)
          ? (json['distance'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'profile_pic': profilePic,
      'distance': distance,
    };
  }
}
