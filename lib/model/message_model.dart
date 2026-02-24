class ChatMessage {
  final int messageId;
  final int thread;
  final Sender? sender;
  final String? content;
  final String messageType;
  final String? attachment;
  final bool isRead;
  final bool isLike;
  final DateTime createdAt;
  final List<dynamic> reactions;

  // 🔹 Local/UI only fields
  bool? isUploading;
  String? localPath;
  bool? isFailed;

  ChatMessage({
    required this.messageId,
    required this.thread,
    this.sender,
    this.content,
    required this.messageType,
    this.attachment,
    required this.isRead,
    required this.isLike,
    required this.createdAt,
    required this.reactions,
    this.isUploading,
    this.localPath,
    this.isFailed,
  });

  /// ================= BACKEND =================

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['message_id'],
      thread: json['thread'],
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
      content: json['content'],
      messageType: json['message_type'] ?? "text",
      attachment: json['attachment'],
      isRead: json['is_read'] ?? false,
      isLike: json['is_like'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
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
      'created_at': createdAt.toIso8601String(),
      'reactions': reactions,
    };
  }

  /// ================= LOCAL (IMPORTANT) =================

  /// Create temp message (image/text before server response)
  factory ChatMessage.local({
    required int thread,
    required int myId,
    String? content,
    String? localPath,
    String messageType = "text",
  }) {
    return ChatMessage(
      messageId: DateTime.now().millisecondsSinceEpoch,
      thread: thread,
      sender: Sender(
        userId: myId,
        email: "",
        username: "",
        fullName: "",
        profilePic: "",
      ),
      content: content,
      messageType: messageType,
      attachment: null,
      isRead: false,
      isLike: false,
      createdAt: DateTime.now(),
      reactions: [],
      isUploading: true,
      localPath: localPath,
    );
  }

  /// Copy with update (VERY IMPORTANT)
  ChatMessage copyWith({
    int? messageId,
    int? thread,
    Sender? sender,
    String? content,
    String? messageType,
    String? attachment,
    bool? isRead,
    bool? isLike,
    DateTime? createdAt,
    List<dynamic>? reactions,
    bool? isUploading,
    String? localPath,
    bool? isFailed,
  }) {
    return ChatMessage(
      messageId: messageId ?? this.messageId,
      thread: thread ?? this.thread,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      attachment: attachment ?? this.attachment,
      isRead: isRead ?? this.isRead,
      isLike: isLike ?? this.isLike,
      createdAt: createdAt ?? this.createdAt,
      reactions: reactions ?? this.reactions,
      isUploading: isUploading ?? this.isUploading,
      localPath: localPath ?? this.localPath,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}

class Sender {
  final int userId;
  final String email;
  final String? username;
  final String fullName;
  final String profilePic;

  Sender({
    required this.userId,
    required this.email,
    required this.username,
    required this.fullName,
    required this.profilePic,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      userId: json['user_id'],
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
