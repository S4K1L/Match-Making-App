class CallResponse {
  final String type;
  final bool success;
  final String message;
  final CallModel data;

  CallResponse({
    required this.type,
    required this.success,
    required this.message,
    required this.data,
  });

  factory CallResponse.fromJson(Map<String, dynamic> json) {
    return CallResponse(
      type: json['type'] ?? '',
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CallModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class CallModel {
  final String callId;
  final String channel;
  final String callType;
  final String status;
  final int callerId;
  final int receiverId;
  final String callerFullName;
  final String callerProfilePic;
  final String receiverFullName;
  final String receiverProfilePic;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? endedAt;
  final String? endReason;

  CallModel({
    required this.callId,
    required this.channel,
    required this.callType,
    required this.status,
    required this.callerId,
    required this.receiverId,
    required this.callerFullName,
    required this.callerProfilePic,
    required this.receiverFullName,
    required this.receiverProfilePic,
    required this.createdAt,
    this.acceptedAt,
    this.endedAt,
    this.endReason,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      callId: json['call_id'] ?? '',
      channel: json['channel'] ?? '',
      callType: json['call_type'] ?? '',
      status: json['status'] ?? '',
      callerId: json['caller_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      callerFullName: json['caller_full_name'] ?? '',
      callerProfilePic: json['caller_profile_pic'] ?? '',
      receiverFullName: json['receiver_full_name'] ?? '',
      receiverProfilePic: json['receiver_profile_pic'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      acceptedAt: json['accepted_at'] != null
          ? DateTime.tryParse(json['accepted_at'])
          : null,
      endedAt: json['ended_at'] != null
          ? DateTime.tryParse(json['ended_at'])
          : null,
      endReason: json['end_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'call_id': callId,
      'channel': channel,
      'call_type': callType,
      'status': status,
      'caller_id': callerId,
      'receiver_id': receiverId,
      'caller_full_name': callerFullName,
      'caller_profile_pic': callerProfilePic,
      'receiver_full_name': receiverFullName,
      'receiver_profile_pic': receiverProfilePic,
      'created_at': createdAt.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'end_reason': endReason,
    };
  }
}
