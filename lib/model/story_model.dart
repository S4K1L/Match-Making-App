import 'package:flutter_extension/util/api_constant.dart';

class Story {
  final String id;
  final String? userName;
  final List<String> mediaPaths;
  final bool isMe;

  final int viewCount;
  final int likesCount;
  final bool isLiked;

  final DateTime? createdAt;
  final DateTime? expiresAt;

  Story({
    required this.id,
    this.userName,
    required this.mediaPaths,
    this.isMe = false,
    this.viewCount = 0,
    this.likesCount = 0,
    this.isLiked = false,
    this.createdAt,
    this.expiresAt,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? '',
      userName: json['user'],
      mediaPaths: json['media'] != null
          ? ["${ApiConstant.BASE_URL_IMAGE}${json['media']}"]
          : [],
      isMe: false,
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

  factory Story.local({required List<String> paths, String? userName}) {
    return Story(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: userName ?? "You",
      mediaPaths: paths,
      isMe: true,
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get hasMedia => mediaPaths.isNotEmpty;
}
