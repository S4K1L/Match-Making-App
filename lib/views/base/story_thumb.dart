import 'dart:io';

import 'package:flutter/material.dart';

class StoryThumb extends StatelessWidget {
  final String path;
  const StoryThumb({super.key, required this.path});
  @override
  Widget build(BuildContext context) {
    final isAsset = path.startsWith('assets/');
    return isAsset
        ? Image.asset(path, fit: BoxFit.cover)
        : Image.file(File(path), fit: BoxFit.cover);
  }
}