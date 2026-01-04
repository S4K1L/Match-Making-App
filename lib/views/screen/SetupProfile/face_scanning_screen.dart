

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FaceScanningScreen extends StatefulWidget {
  const FaceScanningScreen({super.key});

  @override
  State<FaceScanningScreen> createState() => _FaceScanningScreenState();
}

class _FaceScanningScreenState extends State<FaceScanningScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  bool _isDetecting = false;
  bool _hasCaptured = false;
  Timer? _faceTimeoutTimer;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceTimeoutTimer = Timer(const Duration(seconds: 8), () async {
      if (!_hasCaptured) {
        await _controller?.stopImageStream();
        showCustomSnackBar(
          "Face not detected. Please try again",
          isError: true,
        );
      }
    });
  }

  // ---------------- CAMERA INIT ----------------
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();

    final frontCamera = _cameras!.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _controller!.initialize();

    if (!mounted) return;
    setState(() {});

    _startImageStream();
  }

  // ---------------- FACE QUALITY CHECK ----------------
  bool _isGoodFace(Face face, Size imageSize) {
    final box = face.boundingBox;

    // Face size
    if (box.width < imageSize.width * 0.30) return false;

    // Center check
    final centerX = imageSize.width / 2;
    final centerY = imageSize.height / 2;

    if ((box.center.dx - centerX).abs() > imageSize.width * 0.25) return false;
    if ((box.center.dy - centerY).abs() > imageSize.height * 0.25) return false;

    // Eyes open (null-safe)
    if (face.leftEyeOpenProbability != null &&
        face.leftEyeOpenProbability! < 0.6)
      return false;

    if (face.rightEyeOpenProbability != null &&
        face.rightEyeOpenProbability! < 0.6)
      return false;

    return true;
  }

  // ---------------- IMAGE STREAM ----------------
  void _startImageStream() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final camera = _cameras!.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    _controller!.startImageStream((CameraImage image) async {
      if (_isDetecting || _hasCaptured) return;
      _isDetecting = true;

      try {
        final WriteBuffer buffer = WriteBuffer();
        for (final Plane plane in image.planes) {
          buffer.putUint8List(plane.bytes);
        }

        final inputImage = InputImage.fromBytes(
          bytes: buffer.done().buffer.asUint8List(),
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation:
                InputImageRotationValue.fromRawValue(
                  camera.sensorOrientation,
                ) ??
                InputImageRotation.rotation0deg,
            format: InputImageFormat.nv21,
            bytesPerRow: image.planes.first.bytesPerRow,
          ),
        );

        final faces = await _faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          final face = faces.first;
          final imageSize = Size(
            image.width.toDouble(),
            image.height.toDouble(),
          );

          if (_isGoodFace(face, imageSize)) {
            _hasCaptured = true;

            await _controller!.stopImageStream();
            await Future.delayed(const Duration(milliseconds: 500));

            await _controller!.pausePreview();
            await Future.delayed(const Duration(milliseconds: 200));

            await _safeCapture();
          }
        }
      } catch (e) {
        debugPrint("Face detect error: $e");
      } finally {
        _isDetecting = false;
      }
    });
  }

  // ---------------- SAFE CAPTURE ----------------
  Future<void> _safeCapture() async {
    if (_controller == null) return;
    if (!_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      final directory = await getTemporaryDirectory();
      final filePath = path.join(
        directory.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final XFile file = await _controller!.takePicture();
      await file.saveTo(filePath);

      debugPrint("Face image saved at $filePath");

      showCustomSnackBar(
        "Face Picture Captured Successfully",
        isError: false, 
      );
    } catch (e) {
      showCustomSnackBar(
        "Image capture failed",
        isError: true, 
      );
    }
  }

  @override
  void dispose() {
    _faceTimeoutTimer?.cancel();
    _controller?.dispose();
    _faceDetector.close();
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  customAppBar(),
                  const SizedBox(height: 24),

                  Container(
                    height: 207,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF6C897A),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          _controller != null &&
                              _controller!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: CameraPreview(_controller!),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  SizedBox(height: 40),
                  CustomButton(onTap: () {
                    Get.offAllNamed(AppRoutes.homeScreen);
                  },
                   text: "Submit"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
