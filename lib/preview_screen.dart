import 'dart:io';

import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final File imageFile;

  const PreviewScreen({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(
        imageFile,
        height: 200.0,
        width: 200.0,
      ),
    );
  }
}
