import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/society_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/society_chat_card.dart';
import 'package:get/get.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final SocietyController _societyController = Get.put(SocietyController());

  @override
  void initState() {
    super.initState();
    _societyController.getAllSociety();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _background(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _customAppbar(),
                  const SizedBox(height: 40),

                  // ✅ Reactive UI
                  Expanded(
                    child: Obx(() {
                      if (_societyController.isLoading.value) {
                        return _shimmerList();
                      }

                      if (_societyController.societyList.isEmpty) {
                        return const Center(child: Text("No societies found"));
                      }

                      return RefreshIndicator(
                        onRefresh: _societyController.getAllSociety,
                        child: ListView.separated(
                          itemCount: _societyController.societyList.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final society =
                                _societyController.societyList[index];

                            return SocietyChatCard(societyModel: society);
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // floatingActionButton: _createButton(),
    );
  }

  Widget _background() {
    return SizedBox.expand(
      child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
    );
  }

  Widget _customAppbar() {
    return Center(
      child: Text(
        "Society",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  // Widget _createButton() {
  //   return InkWell(
  //     onTap: () => Get.to(() => NewCommunityScreen()),
  //     child: Container(
  //       width: 200,
  //       height: 46,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(30),
  //         boxShadow: [
  //           BoxShadow(
  //             color: const Color(0xFFC97E6D).withAlpha(10),
  //             blurRadius: 16,
  //             offset: const Offset(0, 8),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: const [
  //           Icon(Icons.add, color: Color(0xFF234F38)),
  //           SizedBox(width: 5),
  //           Text(
  //             "Create Society",
  //             style: TextStyle(fontSize: 12, color: Color(0xFF234F38)),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _shimmerList() {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, __) => Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
