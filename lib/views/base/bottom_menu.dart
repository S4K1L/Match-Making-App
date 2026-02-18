import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/home_controller.dart';
import 'package:flutter_extension/views/screen/Chat/inbox_screen.dart';
import 'package:flutter_extension/views/screen/Matches/matche_screen.dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/menu_screen.dart';
import 'package:flutter_extension/views/screen/Profile/profile_screen.dart';
import 'package:flutter_extension/views/screen/home/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  final HomeController homeController = Get.find<HomeController>();
  int currentIndex = 0;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          const HomeScreen(),
          const MatcheScreen(),
          const InboxScreen(),
          const ProfileScreen(),
          const MenuScreen(),
        ],
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            _pageController.jumpToPage(
              index,
            ); // Navigate to the corresponding page
          });
        },
      ),
    );
  }
}

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomMenu({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Color colorByIndex(ThemeData theme, int index) {
    return index == currentIndex
        ? const Color(0xFFD4AF37)
        : const Color(0xFF707270);
  }

  BottomNavigationBarItem getItem(
    String image,
    String title,
    ThemeData theme,
    int index,
  ) {
    return BottomNavigationBarItem(
      label: title,
      icon: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SvgPicture.asset(
          image,
          height: 24.0,
          width: 24.0,
          color: colorByIndex(theme, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<BottomNavigationBarItem> menuItems = [
      getItem("assets/icons/home.svg", 'Home', theme, 0),
      getItem("assets/icons/star.svg", 'Matches', theme, 1),
      getItem("assets/icons/chat.svg", 'Chats', theme, 2),
      getItem("assets/icons/profile.svg", 'Profile', theme, 3),
      getItem("assets/icons/menu.svg", 'Menu', theme, 4),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBE1BF),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2EAED2).withOpacity(0.12),
            offset: const Offset(0, -4),
            spreadRadius: 0,
            blurRadius: 9,
          ),
        ],
      ),
      child: ClipRRect(
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFEBE1BF),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFD4AF37),
          currentIndex: currentIndex,
          selectedLabelStyle: const TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            color: Color(0xFF707270),
            fontWeight: FontWeight.w400,
          ),
          onTap: onTap,

          items: menuItems,
        ),
      ),
    );
  }
}
