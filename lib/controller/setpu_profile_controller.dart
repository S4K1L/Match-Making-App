// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/model/multi_body.dart';
import 'package:flutter_extension/model/profile_update_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SetpuProfileController extends GetxController {
  final ApiService _apiService = ApiService();
  var distance = 50.0.obs;

  /// Q4: Gender (Female, Male, Other)
  var selectedMan = ''.obs;

  /// Q5: Who to connect with (Women, Men, Non-Binary, Choose All)
  var selectedLookingFor = ''.obs;

  var selectedIndex = 0.obs;
  var selectedHeight = "".obs;

  var heightList = List.generate(11, (i) => 5 + i * 0.1);

  final ImagePicker picker = ImagePicker();

  RxList<XFile?> images = List<XFile?>.filled(6, null, growable: false).obs;
  final Rxn<XFile> profileImage = Rxn<XFile>();
  final RxBool profilePhotoUploading = false.obs;

  // Q1
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final heightFeetController = TextEditingController();
  final heightInchesController = TextEditingController();
  // Q2
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  var countryCode = 'BD'.obs;
  // Q11
  final bioController = TextEditingController();

  final RxBool profileUpdating = false.obs;
  final RxBool photosUploading = false.obs;

  Future<void> profileImagePicker() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = picked;
    }
  }

  Future<void> pickImage(int index) async {
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      images[index] = pickedImage;
      images.refresh();
    }
  }

  void removeImage(int index) {
    images[index] = null;
    images.refresh();
  }

  final RxSet<String> selectedLifeStyle = <String>{}.obs;

  final RxSet<String> selectedItems = <String>{}.obs;

  void toggleLife(String item) {
    if (selectedLifeStyle.contains(item)) {
      selectedLifeStyle.remove(item);
    } else {
      selectedLifeStyle.add(item);
    }
  }

  void toggleItem(String item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
  }

  void toggleSelectedItem(String item) {
    if (selected.contains(item)) {
      selected.remove(item);
    } else {
      selected.add(item);
    }
  }

  void toggleProfessionSelectedItem(String item) {
    if (selectedProfession.contains(item)) {
      selectedProfession.remove(item);
    } else {
      selectedProfession.add(item);
    }
  }

  bool isSelectedLifeStype(String item) => selectedLifeStyle.contains(item);
  var selectedRelations = <String>[].obs;

  final RxSet<String> selected = <String>{}.obs;
  final RxSet<String> selectedProfession = <String>{}.obs;

  bool isSelected(String item) => selected.contains(item);

  bool isSelectedProfession(String item) => selectedProfession.contains(item);

  void toggle(String key) {
    if (selected.contains(key)) {
      selected.remove(key);
    } else {
      selected.add(key);
    }
  }

  final List<Map<String, dynamic>> hobbies = [
    {"name": "BOOKS", "icon": "assets/images/m.png"},
    {"name": "Gaming", "icon": "assets/images/g.png"},
    {"name": "History", "icon": "assets/images/h.png"},
    {"name": "Academics", "icon": "assets/images/a.png"},
    {"name": "Travel", "icon": "assets/images/t.png"},
    {"name": "Fitness", "icon": "assets/images/f.png"},
    {"name": "Cooking", "icon": "assets/images/c.png"},
    {"name": "Fashion", "icon": "assets/images/f.png"},
    {"name": "Outdoors", "icon": "assets/images/r.png"},
    {"name": "Wellness", "icon": "assets/images/t.png"},
    {"name": "Wine", "icon": "assets/images/w.png"},
    {"name": "Dancing", "icon": "assets/images/m.png"},
    {"name": "Gardening", "icon": "assets/images/g.png"},
    {"name": "Dogs", "icon": "assets/images/h.png"},
    {"name": "Business", "icon": "assets/images/a.png"},
    {"name": "Finance", "icon": "assets/images/t.png"},
    {"name": "Tech", "icon": "assets/images/f.png"},
    {"name": "Education", "icon": "assets/images/c.png"},
    {"name": "Science", "icon": "assets/images/f.png"},
    {"name": "Health", "icon": "assets/images/c.png"},
    {"name": "Marketing", "icon": "assets/images/f.png"},
    {"name": "Engineering", "icon": "assets/images/r.png"},
    {"name": "Sales", "icon": "assets/images/t.png"},
    {"name": "Leadership", "icon": "assets/images/g.png"},
  ];

  final RxList<String> selectedHobbies = <String>[].obs;

  void toggleHobby(String hobby) {
    if (selectedHobbies.contains(hobby)) {
      selectedHobbies.remove(hobby);
    } else {
      selectedHobbies.add(hobby);
    }
  }

  bool isSelectedField(String key) {
    return selectedHobbies.contains(key);
  }

  void toggleSelection(String item) {
    if (selectedRelations.contains(item)) {
      selectedRelations.remove(item);
    } else {
      selectedRelations.add(item);
    }
  }

  void selectAll() {
    selectedRelations.value = [
      "Love",
      "Friendship",
      "Networking",
      "Neurodiverse Connection",
      "Adventure Partner",
    ];
  }

  void deselectAll() {
    selectedRelations.clear();
  }

  ProfileUpdateModel buildProfileUpdateModel() {
    // Distance calculation logic
    int? dist;
    if (distance.value.isFinite && distance.value <= 1000) {
      dist = distance.value.round();
    } else if (distance.value > 1000 || distance.value.isInfinite) {
      dist = 99999; // Default to a large distance
    }

    // Parse height in feet and inches
    int? feet = int.tryParse(heightFeetController.text.trim());
    int? inches = int.tryParse(heightInchesController.text.trim());

    return ProfileUpdateModel(
      // Full name
      fullName: fullNameController.text.trim().isEmpty
          ? null
          : fullNameController.text.trim(),

      // Date of birth, normalize if empty
      dob: dobController.text.trim().isEmpty
          ? null
          : _normalizeDob(dobController.text.trim()),

      // Height in feet and inches
      heightFeet: feet,
      heightInches: inches,

      country: countryCode.trim().isEmpty ? null : countryCode.trim(),

      // City and Province
      city: cityController.text.trim().isEmpty
          ? null
          : cityController.text.trim(),
      province: provinceController.text.trim().isEmpty
          ? null
          : provinceController.text.trim(),

      // Location
      location: _buildLocation(),

      // Distance
      distance: dist,

      // Gender
      gender: selectedMan.value.isEmpty ? null : selectedMan.value,

      // Brings (array of relations)
      brings: selectedRelations.isEmpty
          ? null
          : selectedRelations.map((e) => e.toUpperCase()).toList(),

      // That (array of personal traits and interests)
      that: selected.isEmpty
          ? null
          : selected.map((e) => e.toUpperCase().replaceAll(' ', '_')).toList(),

      // Looking for (relationship goals)
      lookingFor: selectedLookingFor.value.isEmpty
          ? null
          : [selectedLookingFor.value],

      // Professional field (array)
      professionalField: selectedProfession.isEmpty
          ? null
          : selectedProfession.toList(),

      // Interests (array)
      interests: selectedHobbies.isEmpty ? null : selectedHobbies.toList(),

      // Lifestyle (array)
      lifestyle: selectedLifeStyle.isEmpty ? null : selectedLifeStyle.toList(),

      // Hobbies (array)
      hobbies: selectedHobbies.isEmpty ? null : selectedHobbies.toList(),

      // Bio
      bio: bioController.text.trim().isEmpty ? null : bioController.text.trim(),
    );
  }

  String? _buildLocation() {
    final c = cityController.text.trim();
    final p = provinceController.text.trim();
    if (c.isEmpty && p.isEmpty) return null;
    if (c.isEmpty) return p;
    if (p.isEmpty) return c;
    return '$p, $c';
  }

  /// DD/MM/YY or similar -> YYYY-MM-DD
  String _normalizeDob(String input) {
    final parts = input.split(RegExp(r'[/\-.\s]'));
    if (parts.length >= 3) {
      final d = parts[0].padLeft(2, '0');
      final m = parts[1].padLeft(2, '0');
      final y = parts[2].length == 2 ? '20${parts[2]}' : parts[2];
      return '$y-$m-$d';
    }
    return input;
  }

  Future<bool> updateProfile() async {
    profileUpdating.value = true;
    try {
      final model = buildProfileUpdateModel();
      final result = await _apiService.patch(
        ApiConstant.updateProfile,
        model.toJson(),
        authReq: true,
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        // On success, get user info and return true
        await Get.find<UserController>().getInfo();
        return true;
      } else {
        // Handle errors with status code other than 200 or 201
        debugPrint('Failed to update profile: ${result.statusCode}');
        return false;
      }
    } catch (e) {
      // Catch any exceptions and print them for debugging
      debugPrint('Error updating profile: $e');
      return false;
    } finally {
      // Always set profileUpdating to false after completion
      profileUpdating.value = false;
    }
  }

  /// Upload pop images from AddPhotoScreen (non-null images only).
  Future<bool> uploadPopImages() async {
    photosUploading.value = true;
    final files = <File>[];
    try {
      for (final x in images) {
        if (x != null && x.path.isNotEmpty) {
          final f = File(x.path);
          if (f.existsSync()) files.add(f);
        }
      }
      if (files.isEmpty) return true;
      final multipart = files
          .map((f) => MultipartBody(key: 'image', file: f))
          .toList();
      final result = await _apiService.postMultipartData(
        ApiConstant.popImages,
        {},
        authReq: true,
        multipartBody: multipart,
      );
      if (result.statusCode == 200 || result.statusCode == 201) return true;
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      photosUploading.value = false;
    }
  }

  Future<bool> editProfile() async {
    profileUpdating.value = true;

    try {
      final model = buildProfileUpdateModel();

      MultipartBody? imagePart;

      if (profileImage.value != null && profileImage.value!.path.isNotEmpty) {
        final file = File(profileImage.value!.path);

        if (file.existsSync()) {
          imagePart = MultipartBody(
            key: "profile_pic", // 🔥 confirm this with backend
            file: file,
          );
        }
      }

      final result = await _apiService.patchMultipartData(
        ApiConstant.updateProfile,
        model.toJson(),
        multipartBody: imagePart != null ? [imagePart] : [],
        authReq: true,
      );

      if (result.statusCode == 200 || result.statusCode == 201) {
        await Get.find<UserController>().getInfo();
        return true;
      }

      debugPrint('Failed: ${result.statusCode} ${result.body}');
      return false;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    } finally {
      profileUpdating.value = false;
    }
  }

  void clearProfileImage() {
    profileImage.value = null;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    dobController.dispose();
    heightFeetController.dispose();
    heightInchesController.dispose();
    cityController.dispose();
    provinceController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
