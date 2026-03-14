import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_extension/services/shared_prefs_service.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/continue_journey_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class EnableLocationScreen extends StatefulWidget {
  const EnableLocationScreen({super.key});

  @override
  State<EnableLocationScreen> createState() => _EnableLocationScreenState();
}

class _EnableLocationScreenState extends State<EnableLocationScreen> {
  bool _isLoading = false;

  Future<void> _requestLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var status = await Permission.locationWhenInUse.request();

      if (status.isGranted) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          if (Platform.isIOS) {
            Get.to(() => const ContinueJourneyScreen());
            return;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location services are disabled.')),
            );
            return;
          }
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        await SharedPrefsService.set("latitude", position.latitude);
        await SharedPrefsService.set("longitude", position.longitude);

        Get.to(() => const ContinueJourneyScreen());
      } else {
        if (Platform.isIOS) {
          Get.to(() => const ContinueJourneyScreen());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required.')),
          );
        }
      }
    } catch (e) {
      if (Platform.isIOS) {
        Get.to(() => const ContinueJourneyScreen());
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customAppBar(),

                const SizedBox(height: 172),
                Center(child: SvgPicture.asset('assets/icons/location.svg')),
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    "Enable Location",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Center(
                    child: Text(
                      "You need to enable location to be able to use the BLINK App",

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2A2D2A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0C312B),
                          ),
                        )
                      : CustomButton(
                          onTap: _requestLocation,
                          text: "Allow Location",
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
