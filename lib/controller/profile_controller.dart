import 'package:get/get.dart';

class ProfileController extends GetxController {
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
}
