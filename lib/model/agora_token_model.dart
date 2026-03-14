class AgoraTokenResponse {
  final String token;
  final int uid;

  AgoraTokenResponse({required this.token, required this.uid});

  factory AgoraTokenResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return AgoraTokenResponse(
      token: data['token'] ?? '',
      uid: data['uid'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {'token': token, 'uid': uid},
    };
  }
}
