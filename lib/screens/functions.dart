import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:camera_app/screens/camera_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

storeImage(XFile image) async {
  try {
    String folderPath = await getFilePath();
    String filename = image.name;
    String filePath = '$folderPath$filename';
    File tempFile = File(image.path);
    await tempFile.copy(filePath);
    databaseStoring(filePath);
  } catch (e) {
    log(e.toString());
  }
}

getFilePath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  final Directory appDocDirFolder = Directory('${appDocumentsDirectory.path}/images/');
  if (await appDocDirFolder.exists()) {
    return appDocDirFolder.path;
  } else {
    final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
    return appDocDirNewFolder.path;
  }
}

databaseStoring(String imagepath) {
  final Box<String> imageDB = Hive.box('images');
  imageDB.add(imagepath);
  getImages();
}

getImages() async {
  final Box<String> imageDB =await Hive.openBox('images');
  imageList.clear();
  for (String path in imageDB.values) {
    imageList.add(path);
  }
}
