import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/screens/functions.dart';
import 'package:camera_app/screens/gallery.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraController controller = CameraController(cameras[0], ResolutionPreset.max);
  bool showFocusCircle = false;
  double x = 0;
  double y = 0;

  @override
  void initState() {
    super.initState();
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: const Text('Camera Access Denied'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok'))
                ],
              ),
            );
            break;
          default:
            log(e.toString());
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTapUp: (details) {
                _onTap(details);
              },
              child: Stack(
                children: [
                  CameraPreview(controller),
                  if (showFocusCircle)
                    Positioned(
                      top: y - 20,
                      left: x - 20,
                      child: Container(
                        height: size.width * 0.2,
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          Positioned(
            left: size.width * 0.42,
            bottom: size.height * 0.01,
            child: InkWell(
              onTap: () {
                takePicture();
              },
              borderRadius: BorderRadius.circular(size.width * 0.08),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: size.width * 0.08,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: imageList.isNotEmpty
          ? InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Gallery(),
                ));
              },
              child: Container(
                height: size.width * 0.15,
                width: size.width * 0.15,
                decoration: BoxDecoration(
                    border: Border.all(width: size.width * 0.005, color: Colors.white),
                    borderRadius: BorderRadius.circular(size.width * 0.02),
                    image: DecorationImage(
                        image: FileImage(
                          File(imageList[imageList.length - 1]),
                        ),
                        fit: BoxFit.cover)),
              ),
            )
          : const SizedBox(),
    );
  }

  takePicture() async {
    if (!controller.value.isInitialized) {
      return;
    }
    if (controller.value.isTakingPicture) {
      return;
    }
    try {
      await controller.setFlashMode(FlashMode.off);
      XFile data = await controller.takePicture();
      await storeImage(data);
      log(data.path);
      setState(() {});
    } on CameraException catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;
      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;
      double xp = x / fullWidth;
      double yp = y / cameraHeight;
      Offset point = Offset(xp, yp);
      log("point : $point");
      await controller.setFocusPoint(point);
      setState(() {
        Future.delayed(const Duration(milliseconds: 2200)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }
}

List<String> imageList = [];
