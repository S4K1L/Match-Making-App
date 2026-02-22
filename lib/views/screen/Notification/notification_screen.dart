import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/notification_controller.dart';
import 'package:flutter_extension/model/notification_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controller = Get.put(NotificationController());
  @override
  void initState() {
    super.initState();
    controller.fetchNotifications();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                const SizedBox(height: 24),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.notifications.isEmpty) {
                      return const Center(child: Text("No notifications"));
                    }

                    return RefreshIndicator(
                      onRefresh: controller.fetchNotifications,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: controller.notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (_, index) {
                          final item = controller.notifications[index];
                          return _NotificationItem(item: item);
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel item;

  const _NotificationItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Avatar(image: item.image),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF001C13),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.formattedTime,
                style: const TextStyle(fontSize: 14, color: Color(0xFF001C13)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? image;

  const _Avatar({this.image});

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty) {
      return const CircleAvatar(radius: 27, child: Icon(Icons.notifications));
    }

    return CircleAvatar(radius: 27, backgroundImage: NetworkImage(image!));
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          InkWell(
            onTap: Get.back,
            child: const Icon(Icons.arrow_back_ios, color: Color(0xFF707270)),
          ),
          const Spacer(),
          Text(
            "Notification",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
