class OthersStoryResponseModel {
  final int userId;
  final String username;
  final List<OthersStoryModel> stories;

  OthersStoryResponseModel({
    required this.userId,
    required this.username,
    required this.stories,
  });

  factory OthersStoryResponseModel.fromJson(Map<String, dynamic> json) {
    return OthersStoryResponseModel(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      stories: (json['stories'] as List? ?? [])
          .map((e) => OthersStoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'stories': stories.map((e) => e.toJson()).toList(),
    };
  }
}

class OthersStoryModel {
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

  OthersStoryModel({
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

  factory OthersStoryModel.fromJson(Map<String, dynamic> json) {
    return OthersStoryModel(
      id: json['id'] ?? '',
      user: json['user'] ?? '',
      userId: json['user_id'] ?? 0,
      userFullName: json['user_full_name'] ?? '',

      text: json['text'] as String?,
      media: json['media'] as String?,

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

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
