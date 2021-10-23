import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_teknikal/preview_screen.dart';

import '../main.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    onNewCameraSelected(cameras[0]); // 0 means back camera, 1 means front camera
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized ? _buildCameraPreviewWidget() : Container(),
    );
  }

  Widget _buildCameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    /*
    alternatifnya
    return AspectRatio(
      aspectRatio: 1 / controller!.value.aspectRatio,
      child: controller!.buildPreview(),
    );
     */

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 500,
          child: CameraPreview(controller!),
        ),
        SizedBox(height: 16),
        InkWell(
          onTap: () async {
            XFile? rawImage = await takePicture();
            File imageFile = File(rawImage!.path);

            int currentUnix = DateTime.now().millisecondsSinceEpoch;
            final directory = await getApplicationDocumentsDirectory();
            String fileFormat = imageFile.path.split('.').last;

            await imageFile.copy(
              '${directory.path}/$currentUnix.$fileFormat',
            );

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(imageFile: imageFile),
                ));
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.circle, color: Colors.grey.shade900, size: 80),
              Icon(Icons.circle, color: Colors.grey, size: 65),
            ],
          ),
        ),
      ],
    );
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occurred while taking picture: $e');
      return null;
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }
}
