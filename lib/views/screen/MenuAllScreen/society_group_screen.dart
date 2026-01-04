import 'package:flutter/material.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/system_chrom.dart';
import 'package:get/get.dart';

class SocietyGroupScreen extends StatefulWidget {
  const SocietyGroupScreen({super.key});

  @override
  State<SocietyGroupScreen> createState() => _SocietyGroupScreenState();
}

class _SocietyGroupScreenState extends State<SocietyGroupScreen> {
  @override
  void initState() {
    systemChrom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.blackBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),

                      const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
                Column(
                  children: [
                    const Center(
                      child: Text(
                        "Active & Adventure Society",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF6C53E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        "A curated space for hikers, gym lovers, outdoor explorers, and Adventure Seekers",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFF6C53E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(child: Image.asset('assets/images/adventure.jpg')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
