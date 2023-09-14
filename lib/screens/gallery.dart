import 'dart:io';

import 'package:camera_app/screens/camera_screen.dart';
import 'package:camera_app/screens/image_view.dart';
import 'package:flutter/material.dart';

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: imageList.length,
          padding: EdgeInsets.all(size.height * 0.005),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: size.height * 0.005,
            crossAxisSpacing: size.height * 0.005,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Imageview(index: index),
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover, image: FileImage(File(imageList[index]))),
                borderRadius: BorderRadius.all(Radius.circular(size.height * 0.01)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
