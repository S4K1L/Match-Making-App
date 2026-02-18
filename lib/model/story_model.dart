class Story {
  final String userName;
  final List<String> mediaPaths;
  final bool isMe;

  Story({
    required this.userName,
    required this.mediaPaths,
    this.isMe = false,
  });
}