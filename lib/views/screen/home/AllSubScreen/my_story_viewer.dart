import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/my_story_controller.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/model/my_story_model.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MyStoryViewer extends StatefulWidget {
  final String thumb;
  final String storyId;
  const MyStoryViewer({super.key, required this.thumb, required this.storyId});

  @override
  State<MyStoryViewer> createState() => _MyStoryViewerState();
}

class _MyStoryViewerState extends State<MyStoryViewer> {
  final c = Get.put(MyStoryController());
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    c.getStories();
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
          Obx(() => _body(context)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (c.isLoading.value) return const _StoryShimmer();

    if (c.myStories.isEmpty) {
      return const Center(child: Text("No stories available"));
    }

    final story = c.currentStory!;
    return _content(context, story);
  }

  Widget _content(BuildContext context, MyStoryModel story) {
    final ph = MediaQuery.of(context).size.height * 0.88;
    final inset = MediaQuery.of(context).padding.bottom;
    final closedBottom = -ph - inset;

    return Stack(
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _storyCard(context, story),
                const SizedBox(height: 10),
                _BottomActions(story: story),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),

        /// overlay
        Obx(
          () => c.showViewers.value
              ? Positioned.fill(
                  child: GestureDetector(
                    onTap: c.closeViewers,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: 0.22,
                      child: Container(color: Colors.black),
                    ),
                  ),
                )
              : const SizedBox(),
        ),

        /// viewers panel
        Obx(
          () => AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            bottom: c.showViewers.value ? 0 : closedBottom,
            left: 0,
            right: 0,
            height: ph,
            child: _ViewersPanel(story: story, close: c.closeViewers),
          ),
        ),
      ],
    );
  }

  Widget _storyCard(BuildContext context, MyStoryModel story) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.80,
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

  Widget _media(MyStoryModel story) {
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

  Widget _topBar(MyStoryModel story) {
    return Positioned(
      top: 12,
      left: 12,
      right: 8,
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              _userController.userInfo.value!.profilePic,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userController.userInfo.value!.fullName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                _formatTime(story.createdAt),
                style: const TextStyle(color: Color(0xFFA7A7A7), fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
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

class _BottomActions extends StatelessWidget {
  final MyStoryModel story;

  const _BottomActions({required this.story});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MyStoryController>();

    return Row(
      children: [
        InkWell(
          onTap: c.openViewers,
          child: _OverlappingViewers(viewers: story.viewers),
        ),
        const Spacer(),
        InkWell(
          onTap: c.pickAddStoryImage,
          child: Column(
            children: [
              SvgPicture.asset('assets/icons/story.svg'),
              const SizedBox(height: 8),
              const Text("Add story"),
            ],
          ),
        ),
      ],
    );
  }
}

class _StoryShimmer extends StatelessWidget {
  const _StoryShimmer();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.80;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              _shimmerBox(height),
              const SizedBox(height: 12),
              Row(
                children: [
                  _shimmerChip(100),
                  const Spacer(),
                  Column(
                    children: [
                      _shimmerBox(24, width: 24),
                      const SizedBox(height: 6),
                      _shimmerBox(10, width: 60),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox(double height, {double? width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _shimmerChip(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 28,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

// -------- Segmented progress bar --------
class _StoryProgressBar extends StatelessWidget {
  const _StoryProgressBar();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MyStoryController>();
    const barH = 4.0, gap = 6.0;

    return Obx(
      () => Row(
        children: List.generate(c.myStories.length, (i) {
          final isCurrent = i == c.currentIndex.value;
          final isPast = i < c.currentIndex.value;

          return Expanded(
            child: Container(
              height: barH,
              margin: const EdgeInsets.symmetric(horizontal: gap / 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.35), // track
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  if (isPast)
                    Positioned.fill(child: Container(color: Colors.white)),
                  if (isCurrent)
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
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

// -------- Viewers Panel --------
class _ViewersPanel extends StatelessWidget {
  final MyStoryModel story;
  final VoidCallback close;

  const _ViewersPanel({required this.story, required this.close});

  @override
  Widget build(BuildContext context) {
    final viewers = story.viewers;

    return GestureDetector(
      onVerticalDragUpdate: (d) {
        if (d.delta.dy > 8) close();
      },
      child: Material(
        elevation: 12,
        color: Colors.transparent,
        child: Stack(
          children: [
            /// Background (OLD UI)
            SizedBox.expand(
              child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
            ),

            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// Drag handle
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Header (OLD UI)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF18433B),
                            foregroundColor: const Color(0xFF0C312B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: close,
                          child: const Text(
                            "Done",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 145,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 2, // story + add story
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        /// 1️⃣ Story thumbnail
                        if (index == 0) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: 92,
                              height: 145,
                              color: const Color(0xFFEFF1F4),
                              child: story.media != null
                                  ? Image.network(
                                      story.media!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      Images.greeyBackground,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        }

                        return _AddStoryCard(
                          onTap: () {
                            final controller = Get.find<MyStoryController>();
                            controller.pickAddStoryImage();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Title (FIXED with new data)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Viewers(${viewers.length})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Viewer list (OLD UI + NEW DATA)
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 4, bottom: 18),
                      itemCount: viewers.length,
                      separatorBuilder: (_, _) => const SizedBox(),
                      itemBuilder: (context, i) {
                        final v = viewers[i];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                (v.profilePic != null &&
                                    v.profilePic!.isNotEmpty)
                                ? NetworkImage(v.profilePic!)
                                : null,
                            child:
                                (v.profilePic == null || v.profilePic!.isEmpty)
                                ? Text(
                                    v.fullName.isNotEmpty
                                        ? v.fullName[0].toUpperCase()
                                        : "?",
                                  )
                                : null,
                          ),

                          title: Text(
                            v.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF1A1A1A),
                              fontSize: 14,
                            ),
                          ),

                          subtitle: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Color(0xFF707270),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                v.distance != null ? "${v.distance} km" : "",
                                style: const TextStyle(
                                  color: Color(0xFF707270),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddStoryCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddStoryCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 92,
        height: 104,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/story.svg'),
            const SizedBox(height: 6),
            const Text(
              "Add story",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF707270),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------- Helpers --------
class _OverlappingViewers extends StatelessWidget {
  final List<StoryViewerModel> viewers;

  const _OverlappingViewers({required this.viewers});

  @override
  Widget build(BuildContext context) {
    const size = 28.0;
    const overlap = 12.0;

    final list = viewers.take(3).toList();

    if (list.isEmpty) return const SizedBox();

    return SizedBox(
      height: size,
      width: size + (list.length - 1) * overlap,
      child: Stack(
        children: List.generate(list.length, (i) {
          final v = list[i];

          return Positioned(
            left: i * overlap,
            child: CircleAvatar(
              radius: size / 2,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: size / 2 - 2,
                backgroundImage:
                    (v.profilePic != null && v.profilePic!.isNotEmpty)
                    ? NetworkImage(v.profilePic!)
                    : null,
                child: (v.profilePic == null || v.profilePic!.isEmpty)
                    ? Text(
                        v.fullName.isNotEmpty
                            ? v.fullName[0].toUpperCase()
                            : "?",
                      )
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
