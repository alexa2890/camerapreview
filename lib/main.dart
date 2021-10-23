import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test_teknikal/selector_screen.dart';

// ref: https://blog.logrocket.com/flutter-camera-plugin-deep-dive-with-examples/

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SelectorScreen(),
    );
  }
}
