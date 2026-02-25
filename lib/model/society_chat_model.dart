import 'package:flutter_extension/util/api_constant.dart';

class SocietyChatModel {
  final int id;
  final int society;
  final Sender? sender;
  final String content;
  final String messageType;
  final String? attachment;
  final DateTime createdAt;
  final bool? isUploading;
  final bool? isFailed;

  SocietyChatModel({
    required this.id,
    required this.society,
    required this.sender,
    required this.content,
    required this.messageType,
    this.attachment,
    required this.createdAt,
    this.isUploading = false,
    this.isFailed = false,
  });

  factory SocietyChatModel.fromJson(Map<String, dynamic> json) {
    return SocietyChatModel(
      id: json['id'] ?? 0,
      society: json['society'] ?? 0,
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
      content: json['content'] ?? '',
      messageType: json['message_type'] ?? '',
      attachment: resolveAttachment(json['attachment']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'society': society,
      'sender': sender?.toJson(),
      'content': content,
      'message_type': messageType,
      'attachment': attachment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  SocietyChatModel copyWith({
    int? id,
    int? society,
    Sender? sender,
    String? content,
    String? messageType,
    String? attachment,
    DateTime? createdAt,
    bool? isUploading,
    bool? isFailed,
  }) {
    return SocietyChatModel(
      id: id ?? this.id,
      society: society ?? this.society,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      attachment: attachment ?? this.attachment,
      createdAt: createdAt ?? this.createdAt,
      isUploading: isUploading ?? this.isUploading,
      isFailed: isFailed ?? this.isFailed,
    );
  }

  static String? resolveAttachment(String? path) {
    if (path == null || path.isEmpty) return null;

    if (path.startsWith("/storage") || path.startsWith("/data")) {
      return path;
    }

    if (path.startsWith("http")) {
      return path;
    }

    return ApiConstant.BASE_URL_IMAGE + path;
  }
}

class Sender {
  final int userId;
  final String email;
  final String username;
  final String fullName;
  final String? profilePic;
  final bool isOnline;

  Sender({
    required this.userId,
    required this.email,
    required this.username,
    required this.fullName,
    this.profilePic,
    required this.isOnline,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      userId: json['user_id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      profilePic: json['profile_pic'],
      isOnline: json['is_online'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'username': username,
      'full_name': fullName,
      'profile_pic': profilePic,
      'is_online': isOnline,
    };
  }
}
