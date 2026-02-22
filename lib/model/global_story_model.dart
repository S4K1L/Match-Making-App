class GlobalStoryModel {
  final int? userId;
  final String? username;
  final String? fullName;
  final bool? isOnline;
  final List<String>? hobbies;
  final List<PopImage>? popImages;

  GlobalStoryModel({
    this.userId,
    this.username,
    this.fullName,
    this.isOnline,
    this.hobbies,
    this.popImages,
  });

  factory GlobalStoryModel.fromJson(Map<String, dynamic> json) {
    return GlobalStoryModel(
      userId: json['user_id'],
      username: json['username'],
      fullName: json['full_name'],
      isOnline: json['is_online'],
      hobbies: (json['hobbies'] as List?)?.map((e) => e.toString()).toList(),
      popImages: (json['pop_images'] as List?)
          ?.map((e) => PopImage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'full_name': fullName,
      'is_online': isOnline,
      'hobbies': hobbies,
      'pop_images': popImages?.map((e) => e.toJson()).toList(),
    };
  }
}

class PopImage {
  final int? id;
  final int? user;
  final String? image;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  PopImage({
    this.id,
    this.user,
    this.image,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory PopImage.fromJson(Map<String, dynamic> json) {
    return PopImage(
      id: json['id'],
      user: json['user'],
      image: json['image'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'image': image,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
