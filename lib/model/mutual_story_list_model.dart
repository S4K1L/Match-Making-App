class MutualStoryModel {
  final String? id;
  final String? user;
  final String? text;
  final String? media;
  final int? viewCount;
  final int? likesCount;
  final bool? isLiked;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  MutualStoryModel({
    this.id,
    this.user,
    this.text,
    this.media,
    this.viewCount,
    this.likesCount,
    this.isLiked,
    this.createdAt,
    this.expiresAt,
  });

  factory MutualStoryModel.fromJson(Map<String, dynamic> json) {
    return MutualStoryModel(
      id: json['id']?.toString(),
      user: json['user'],
      text: json['text'],
      media: json['media'],
      viewCount: json['view_count'],
      likesCount: json['likes_count'],
      isLiked: json['is_liked'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'text': text,
      'media': media,
      'view_count': viewCount,
      'likes_count': likesCount,
      'is_liked': isLiked,
      'created_at': createdAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}
