class User {
  final int userId;
  final String email;
  final String phone;
  final String username;
  final String fullName;
  final String profilePic;
  final String profilePicUrl;
  final String gender;
  final List<String> brings;
  final List<String> that;
  final List<String> lookingFor;
  final List<String> professionalField;
  final List<String> interests;
  final List<String> lifestyle;
  final List<String> hobbies;
  final String bio;
  final int heightFeet;
  final int heightInches;
  final String height;
  final int heightInchesTotal;
  final String dob;
  final int age;
  final String city;
  final String province;
  final String location;
  final int distance;
  final bool isVerified;
  final bool isActive;
  final bool isOnline;
  final String? lastLogin;
  final bool isSubscribed;
  final String? subscriptionExpiry;
  final List<PopImage> popImages;
  final String createdAt;
  final String updatedAt;
  final String profileLink;

  User({
    required this.userId,
    required this.email,
    required this.phone,
    required this.username,
    required this.fullName,
    required this.profilePic,
    required this.profilePicUrl,
    required this.gender,
    required this.brings,
    required this.that,
    required this.lookingFor,
    required this.professionalField,
    required this.interests,
    required this.lifestyle,
    required this.hobbies,
    required this.bio,
    required this.heightFeet,
    required this.heightInches,
    required this.height,
    required this.heightInchesTotal,
    required this.dob,
    required this.age,
    required this.city,
    required this.province,
    required this.location,
    required this.distance,
    required this.isVerified,
    required this.isActive,
    required this.isOnline,
    this.lastLogin,
    required this.isSubscribed,
    this.subscriptionExpiry,
    required this.popImages,
    required this.createdAt,
    required this.updatedAt,
    required this.profileLink,
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      profilePic: json['profile_pic'] ?? '',
      profilePicUrl: json['profile_pic_url'] ?? '',
      gender: json['gender'] ?? '',
      brings: List<String>.from(json['brings'] ?? []),
      that: List<String>.from(json['that'] ?? []),
      lookingFor: List<String>.from(json['looking_for'] ?? []),
      professionalField: List<String>.from(json['professional_field'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      lifestyle: List<String>.from(json['lifestyle'] ?? []),
      hobbies: List<String>.from(json['hobbies'] ?? []),
      bio: json['bio'] ?? '',
      heightFeet: json['height_feet'] ?? 0,
      heightInches: json['height_inches'] ?? 0,
      height: json['height'] ?? '',
      heightInchesTotal: json['height_inches_total'] ?? 0,
      dob: json['dob'] ?? '',
      age: json['age'] ?? 0,
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      location: json['location'] ?? '',
      distance: json['distance'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      isOnline: json['is_online'] ?? false,
      lastLogin: json['last_login'],
      isSubscribed: json['is_subscribed'] ?? false,
      subscriptionExpiry: json['subscription_expiry'],
      popImages:
          (json['pop_images'] as List<dynamic>?)
              ?.map((e) => PopImage.fromJson(e))
              .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      profileLink: json['profile_link'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'phone': phone,
      'username': username,
      'full_name': fullName,
      'profile_pic': profilePic,
      'profile_pic_url': profilePicUrl,
      'gender': gender,
      'brings': brings,
      'that': that,
      'looking_for': lookingFor,
      'professional_field': professionalField,
      'interests': interests,
      'lifestyle': lifestyle,
      'hobbies': hobbies,
      'bio': bio,
      'height_feet': heightFeet,
      'height_inches': heightInches,
      'height': height,
      'height_inches_total': heightInchesTotal,
      'dob': dob,
      'age': age,
      'city': city,
      'province': province,
      'location': location,
      'distance': distance,
      'is_verified': isVerified,
      'is_active': isActive,
      'is_online': isOnline,
      'last_login': lastLogin,
      'is_subscribed': isSubscribed,
      'subscription_expiry': subscriptionExpiry,
      'pop_images': popImages.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile_link': profileLink,
    };
  }
}

class PopImage {
  final int id;
  final int user;
  final String image;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  PopImage({
    required this.id,
    required this.user,
    required this.image,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory PopImage.fromJson(Map<String, dynamic> json) {
    return PopImage(
      id: json['id'] ?? 0,
      user: json['user'] ?? 0,
      image: json['image'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // To JSON
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
