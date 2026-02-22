class NotificationModel {
  final String title;
  final String? image;
  final DateTime time;

  NotificationModel({required this.title, this.image, required this.time});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      image: json['image'],
      time: json['time'] != null
          ? DateTime.tryParse(json['time']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    if (difference.inDays < 7) return "${difference.inDays}d ago";

    return "${time.day}/${time.month}/${time.year}";
  }
}
