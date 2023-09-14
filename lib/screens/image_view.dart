import 'dart:io';

import 'package:camera_app/screens/camera_screen.dart';
import 'package:flutter/material.dart';

class Imageview extends StatelessWidget {
  const Imageview({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Center(
          child: PageView.builder(
            controller: PageController(initialPage: index),
            itemBuilder: (context, index) => Image.file(File(imageList[index])),
            itemCount: imageList.length,
          ),
        ),
      ),
    );
  }
}
