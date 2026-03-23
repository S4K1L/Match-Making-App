class AgoraTokenResponse {
  final String token;
  final int uid;

  AgoraTokenResponse({required this.token, required this.uid});

  factory AgoraTokenResponse.fromJson(Map<String, dynamic> json) {
    return AgoraTokenResponse(
      token: json['token'] ?? '',
      uid: json['uid'] is int
          ? json['uid']
          : int.tryParse(json['uid']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {'token': token, 'uid': uid},
    };
  }
}
