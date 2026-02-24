class ChatThreadModel {
  final int threadId;
  final OtherUser? otherUser;
  final DateTime? updatedAt;
  final LastMessage? lastMessage;
  final int unreadCount;

  ChatThreadModel({
    required this.threadId,
    this.otherUser,
    this.updatedAt,
    this.lastMessage,
    required this.unreadCount,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadModel(
      threadId: json['thread_id'] ?? 0,
      otherUser: json['other_user'] != null
          ? OtherUser.fromJson(json['other_user'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thread_id': threadId,
      'other_user': otherUser?.toJson(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
    };
  }
}

class OtherUser {
  final int userId;
  final String? email;
  final String? username;
  final String? fullName;
  final String? profilePic;

  OtherUser({
    required this.userId,
    this.email,
    this.username,
    this.fullName,
    this.profilePic,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) {
    return OtherUser(
      userId: json['user_id'] ?? 0,
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
      profilePic: json['profile_pic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'username': username,
      'full_name': fullName,
      'profile_pic': profilePic,
    };
  }
}

class LastMessage {
  final int messageId;
  final int thread;
  final Sender? sender;
  final String? content;
  final String? messageType;
  final String? attachment;
  final bool isRead;
  final bool isLike;
  final DateTime? createdAt;
  final List<dynamic> reactions;

  LastMessage({
    required this.messageId,
    required this.thread,
    this.sender,
    this.content,
    this.messageType,
    this.attachment,
    required this.isRead,
    required this.isLike,
    this.createdAt,
    required this.reactions,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      messageId: json['message_id'] ?? 0,
      thread: json['thread'] ?? 0,
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
      content: json['content'],
      messageType: json['message_type'],
      attachment: json['attachment'],
      isRead: json['is_read'] ?? false,
      isLike: json['is_like'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      reactions: json['reactions'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'thread': thread,
      'sender': sender?.toJson(),
      'content': content,
      'message_type': messageType,
      'attachment': attachment,
      'is_read': isRead,
      'is_like': isLike,
      'created_at': createdAt?.toIso8601String(),
      'reactions': reactions,
    };
  }
}

class Sender {
  final int userId;
  final String? email;
  final String? username;
  final String? fullName;
  final String? profilePic;

  Sender({
    required this.userId,
    this.email,
    this.username,
    this.fullName,
    this.profilePic,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      userId: json['user_id'] ?? 0,
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
      profilePic: json['profile_pic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'username': username,
      'full_name': fullName,
      'profile_pic': profilePic,
    };
  }
}
