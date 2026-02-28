import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/connection_controller.dart';
import 'package:flutter_extension/controller/others_story_controller.dart';
import 'package:flutter_extension/model/others_story_model.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/screen/Profile/AllSubScreen/report_and_issue_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class OthersStoryViewer extends StatefulWidget {
  final String storyId;

  const OthersStoryViewer({super.key, required this.storyId});

  @override
  State<OthersStoryViewer> createState() => _OthersStoryViewerState();
}

class _OthersStoryViewerState extends State<OthersStoryViewer> {
  final c = Get.put(OthersStoryController());
  final _connectionController = Get.put(ConnectionController());

  @override
  void initState() {
    super.initState();
    c.getStories(widget.storyId);
  }

  @override
  void dispose() {
    c.stopProgress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                _header(),
                Expanded(
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _body(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: Get.back,
            child: const Icon(Icons.arrow_back_ios, color: Color(0xFF2A2D2A)),
          ),
          const Text(
            "Story",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF2A2D2A),
            ),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: SvgPicture.asset('assets/icons/notification.svg'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (c.isLoading.value) {
      return const _StoryShimmer();
    }

    if (c.stories.isEmpty) {
      return const Center(child: Text("No stories available"));
    }

    final story = c.currentStory!;
    return _content(context, story, _connectionController);
  }

  Widget _content(
    BuildContext context,
    OthersStoryModel story,
    ConnectionController connectionController,
  ) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _storyCard(context, story),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _circleBtn("cross", () => Get.back(), gradient: false),
            const SizedBox(width: 20),
            Obx(
              () => _circleBtn(
                "love",
                () {
                  connectionController.toggleLike(story.userId);
                },
                gradient: true,
                color: connectionController.isLiked.value
                    ? Colors.red
                    : Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _storyCard(BuildContext context, OthersStoryModel story) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _media(story)),
            Positioned.fill(child: _gradient()),
            Positioned.fill(child: _tapNavigation()),
            const Positioned(
              top: 8,
              left: 10,
              right: 10,
              child: _StoryProgressBar(),
            ),
            _topBar(story),
          ],
        ),
      ),
    );
  }

  Widget _media(OthersStoryModel story) {
    if (story.media != null) {
      return Image.network(
        story.media!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            const Center(child: Icon(Icons.broken_image)),
      );
    }

    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Text(
        story.text ?? '',
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _gradient() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.22, 0.78, 1.0],
          colors: [
            Colors.black.withValues(alpha: 0.55),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: 0.65),
          ],
        ),
      ),
    );
  }

  Widget _tapNavigation() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: c.prevStory,
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: c.nextStory,
          ),
        ),
      ],
    );
  }

  Widget _topBar(OthersStoryModel story) {
    return Positioned(
      top: 12,
      left: 12,
      right: 8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: story.profilePic != null
                ? NetworkImage(story.profilePic!)
                : const AssetImage("assets/images/olivia.png"),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.fullName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                _formatTime(story.createdAt),
                style: const TextStyle(color: Color(0xFFA7A7A7), fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          PopupMenuButton(
            color: const Color(0xFFFFFFFF),
            onSelected: (value) {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    _connectionController.blockUser(story.userId.toString());
                  },
                  value: 'account ',
                  child: const Text(
                    'Block account ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Get.to(
                      () => ReportAndIssueScreen(id: story.userId.toString()),
                    );
                  },
                  value: 'Report profile',
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Report profile',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(
    String icon,
    VoidCallback onTap, {
    bool gradient = false,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gradient == true ? null : Colors.white,
          gradient: gradient
              ? const LinearGradient(
                  colors: [Color(0xFF18433B), Color(0xFF0C312B)],
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SvgPicture.asset(
            "assets/icons/$icon.svg",
            height: 40,
            width: 40,
            // ignore: unnecessary_null_in_if_null_operators
            color: color ?? null,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }
}

class _StoryProgressBar extends StatelessWidget {
  const _StoryProgressBar();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OthersStoryController>();

    return Obx(
      () => Row(
        children: List.generate(c.stories.length, (i) {
          final isCurrent = i == c.currentIndex.value;
          final isPast = i < c.currentIndex.value;

          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  if (isPast)
                    Positioned.fill(child: Container(color: Colors.white)),
                  if (isCurrent)
                    FractionallySizedBox(
                      widthFactor: c.progress.value.clamp(0.0, 1.0),
                      child: Container(color: const Color(0xFF2EAED2)),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _StoryShimmer extends StatelessWidget {
  const _StoryShimmer();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.70;

    return Column(
      children: [
        const SizedBox(height: 12),

        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _ShimmerCircle(),
            SizedBox(width: 20),
            _ShimmerCircle(),
          ],
        ),
      ],
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  const _ShimmerCircle();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 78,
        width: 78,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
