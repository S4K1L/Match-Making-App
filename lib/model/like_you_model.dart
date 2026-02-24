class LikeYouModel {
  final int userId;
  final String username;
  final String fullName;
  final bool isOnline;
  final String? profilePic;
  final List<String> hobbies;
  final double? distance;

  LikeYouModel({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.isOnline,
    this.profilePic,
    required this.hobbies,
    this.distance,
  });

  factory LikeYouModel.fromJson(Map<String, dynamic> json) {
    return LikeYouModel(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      isOnline: json['is_online'] ?? false,
      profilePic: json['profile_pic'], // nullable
      hobbies:
          (json['hobbies'] as List?)?.map((e) => e.toString()).toList() ?? [],
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "username": username,
      "full_name": fullName,
      "is_online": isOnline,
      "profile_pic": profilePic,
      "hobbies": hobbies,
      "distance": distance,
    };
  }
}
