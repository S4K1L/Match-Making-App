import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SetpuProfileController extends GetxController {
  var distance = 50.0.obs;
  var selectedMan = ''.obs;

  var selectedIndex = 0.obs;
  var selectedHeight = "".obs;

  var heightList = List.generate(11, (i) => 5 + i * 0.1);

  final ImagePicker picker = ImagePicker();

  RxList<XFile?> images = List<XFile?>.filled(6, null, growable: false).obs;

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

  bool isSelectedLifeStype(String item) => selectedLifeStyle.contains(item);
  var selectedRelations = <String>[].obs;

  final RxSet<String> selected = <String>{}.obs;

  bool isSelected(String item) => selected.contains(item);

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

  // Toggle selection for individual items
  void toggleSelection(String item) {
    if (selectedRelations.contains(item)) {
      selectedRelations.remove(item);
    } else {
      selectedRelations.add(item);
    }
  }

  // Select all options
  void selectAll() {
    selectedRelations.value = [
      "Love",
      "Friendship",
      "Networking",
      "Neurodiverse Connection",
      "Adventure Partner",
    ];
  }

  // Deselect all options
  void deselectAll() {
    selectedRelations.clear();
  }
}
