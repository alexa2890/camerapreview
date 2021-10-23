import 'package:flutter/material.dart';
import 'package:test_teknikal/camera_camera_screen.dart';
import 'package:test_teknikal/camera_screen.dart';

class SelectorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Package"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen())),
            child: Text("Camera"),
          ),
          SizedBox(height: 36),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CameraCameraScreen())),
            child: Text("CameraCamera"),
          ),
        ],
      ),
    );
  }
}
