import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:test_teknikal/preview_screen.dart';

class CameraCameraScreen extends StatefulWidget {
  @override
  State<CameraCameraScreen> createState() => _CameraCameraScreenState();
}

class _CameraCameraScreenState extends State<CameraCameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CameraCamera"),
      ),
      body: Stack(
        children: [
          CameraCamera(
            onFile: (file) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewScreen(imageFile: file),
                  ));
            },
          ),
          Text("ini text contoh", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
