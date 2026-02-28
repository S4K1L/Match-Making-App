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
          .map((e) => OthersStoryModel.fromJson(e))
          .toList(),
    );
  }
}

class OthersStoryModel {
  final String id;
  final int userId;
  final String fullName;

  final String? text;
  final String? media;
  final String? profilePic;

  final int viewCount;
  final int likesCount;
  final bool isLiked;

  final DateTime createdAt;
  final DateTime expiresAt;

  OthersStoryModel({
    required this.id,
    required this.userId,
    required this.fullName,
    this.text,
    this.media,
    this.profilePic,
    required this.viewCount,
    required this.likesCount,
    required this.isLiked,
    required this.createdAt,
    required this.expiresAt,
  });

  factory OthersStoryModel.fromJson(Map<String, dynamic> json) {
    return OthersStoryModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? 0,
      fullName: json['full_name'] ?? '',

      text: json['text'],
      media: json['media'],
      profilePic: json['profile_pic'],

      viewCount: json['view_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,

      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
