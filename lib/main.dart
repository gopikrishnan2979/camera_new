import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_app/screens/camera_screen.dart';
import 'package:camera_app/screens/functions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentsDir.path);
  await getImages();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF333333),
        useMaterial3: true,
      ),
      home: const CameraScreen(),
    );
  }
}
