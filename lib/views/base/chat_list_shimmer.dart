import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatListShimmer extends StatelessWidget {
  const ChatListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (_, __) => const _ChatItemShimmer(),
    );
  }
}

class _ChatItemShimmer extends StatelessWidget {
  const _ChatItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _box(46, 46, isCircle: true),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_box(14, 120), const SizedBox(height: 6), _box(12, 180)],
          ),
        ),

        const SizedBox(width: 12),

        Column(
          children: [
            _box(10, 40),
            const SizedBox(height: 6),
            _box(16, 16, isCircle: true),
          ],
        ),
      ],
    );
  }

  Widget _box(double height, double width, {bool isCircle = false}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(8),
        ),
      ),
    );
  }
}
