import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/like_you_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_radio_button.dart';
import 'package:flutter_extension/views/base/search_text_field.dart';
import 'package:get/get.dart';

class AddMemberScreen extends StatefulWidget {
  final int societyId;
  const AddMemberScreen({super.key, required this.societyId});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final LikeYouController _likeYouController = Get.put(LikeYouController());

  @override
  void initState() {
    super.initState();

    _likeYouController.clearSelection();
    _likeYouController.getAllLikeYou();
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
                /// Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: Get.back,
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF001C13),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Add Member",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF001C13),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ✅ Search (CONNECTED)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SearchTextField(
                    controller: _likeYouController.searchController,
                    onChanged: _likeYouController.onSearchChanged,
                    hintText: "Search",
                  ),
                ),

                const SizedBox(height: 22),

                /// LIST
                Expanded(
                  child: Obx(() {
                    if (_likeYouController.isLoading.value &&
                        _likeYouController.likeYouList.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_likeYouController.likeYouList.isEmpty) {
                      return const Center(child: Text("No users found"));
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _likeYouController.likeYouList.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final user = _likeYouController.likeYouList[index];

                        return Row(
                          children: [
                            /// Profile Image
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:
                                      (user.profilePic != null &&
                                          user.profilePic!.isNotEmpty)
                                      ? NetworkImage(user.profilePic!)
                                      : const AssetImage(
                                              'assets/images/olivia.png',
                                            )
                                            as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            /// Name
                            Expanded(
                              child: Text(
                                user.fullName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF001C13),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            /// Selection
                            Obx(() {
                              final isSelected = _likeYouController
                                  .isUserSelected(user.userId.toString());

                              return CustomRadioButton(
                                value: isSelected,
                                onChanged: (_) {
                                  _likeYouController.toggleUserSelection(
                                    user.userId.toString(),
                                  );
                                },
                              );
                            }),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),

      /// BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 93),
        child: Obx(() {
          return CustomButton(
            loading: _likeYouController.isLoading.value,
            onTap: () {
              _likeYouController.addMemebersToSociety(widget.societyId);
            },
            text: "Add (${_likeYouController.selectedUserIds.length})",
          );
        }),
      ),
    );
  }
}
