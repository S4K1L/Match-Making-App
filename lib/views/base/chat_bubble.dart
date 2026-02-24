import 'dart:io';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final String? attachment;
  final String? localPath;
  final String? userProfile;
  final bool? isUploading;
  final bool showAvatar;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.text,
    this.attachment,
    this.userProfile,
    this.localPath,
    this.isUploading,
    this.showAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: _isImage()
          ? const EdgeInsets.all(4)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: BoxDecoration(
        gradient: isMe
            ? const LinearGradient(
                colors: [Color(0xFF18433B), Color(0xFF0C312B)],
              )
            : null,
        color: isMe ? null : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: Radius.circular(isMe ? 12 : 0),
          bottomRight: Radius.circular(isMe ? 0 : 12),
        ),
      ),
      child: _buildContent(),
    );

    if (isMe) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAvatar)
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: userProfile != null
                    ? NetworkImage(userProfile!)
                    : AssetImage('assets/images/olivia.png'),
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          const SizedBox(width: 32),

        const SizedBox(width: 8),
        Flexible(child: bubble),
      ],
    );
  }

  // ================= CONTENT =================

  Widget _buildContent() {
    // 🔹 LOCAL IMAGE (preview)
    if (localPath != null && localPath!.isNotEmpty) {
      return Stack(
        children: [
          _image(FileImage(File(localPath!))),
          if (isUploading == true) _loadingOverlay(),
        ],
      );
    }

    // 🔹 NETWORK IMAGE
    if (attachment != null && attachment!.isNotEmpty) {
      return _image(NetworkImage(attachment!));
    }

    // 🔹 TEXT
    return Text(
      text,
      style: TextStyle(
        color: isMe ? Colors.white : const Color(0xFF707270),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _image(ImageProvider provider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image(image: provider, width: 150, height: 150, fit: BoxFit.cover),
    );
  }

  Widget _loadingOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }

  bool _isImage() {
    return (attachment != null && attachment!.isNotEmpty) ||
        (localPath != null && localPath!.isNotEmpty);
  }
}
