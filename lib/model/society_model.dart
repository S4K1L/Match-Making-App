import 'package:flutter_extension/util/api_constant.dart';

class SocietyModel {
  final int? id;
  final String? name;
  final String? image;
  final int? createdBy;
  final DateTime? createdAt;
  final int? memberCount;
  final List<String>? randomMemberImages;

  SocietyModel({
    this.id,
    this.name,
    this.image,
    this.createdBy,
    this.createdAt,
    this.memberCount,
    this.randomMemberImages,
  });

  factory SocietyModel.fromJson(Map<String, dynamic> json) {
    return SocietyModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      createdBy: json['created_by'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      memberCount: json['member_count'] as int?,
      randomMemberImages:
          (json['random_member_images'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'member_count': memberCount,
      'random_member_images': randomMemberImages,
    };
  }

  SocietyModel copyWith({
    int? id,
    String? name,
    String? image,
    int? createdBy,
    DateTime? createdAt,
    int? memberCount,
    List<String>? randomMemberImages,
  }) {
    return SocietyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      memberCount: memberCount ?? this.memberCount,
      randomMemberImages: randomMemberImages ?? this.randomMemberImages,
    );
  }

  String get fullImage {
    if (image == null) return "";
    if (image!.startsWith("http")) return image!;
    return ApiConstant.BASE_URL_IMAGE + image!;
  }

  List<String> get fullMemberImages {
    return randomMemberImages?.map((e) {
          if (e.startsWith("http")) return e;
          return "${ApiConstant.BASE_URL_IMAGE}/$e";
        }).toList() ??
        [];
  }
}
