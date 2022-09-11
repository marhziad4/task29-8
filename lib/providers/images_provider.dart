import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_emp/controller/ImageDbController.dart';
import 'package:todo_emp/model/taskImage.dart';

class ImagesProvider extends ChangeNotifier {
  ImageDbController _imageDbController = ImageDbController();

  List<taskImage> images = [];
  List<taskImage> images1 = [];
  List<taskImage> imageId = [];
  ImagesProvider() {

    read();
    // readId();
    // readCounter(counter);
  }
  Future<bool> create({required taskImage image}) async {
    //  taskModel task = taskModel()

    if (imageId.length >= 3) {
      return false;
    } else {
      int id = await _imageDbController.create(image);
    // //  images1= await _imageDbController.readId(id);
    //
    //
    //
       print("id create image$id");
    //   images.add(image);
    //   imageId.add(image);
    //  //  print(jsonEncode(images1));
    //    print(jsonEncode(images));
    //   // imageId.add(images[0]);

      notifyListeners();
      return true;
    }
    print('ImagesProvider');
    notifyListeners();
  }

  Future<List<taskImage>?> read() async {
    // completeTasks = await _taskDbController.read2();
    images = await _imageDbController.read();

    // print(jsonEncode(completeTasks));
    // print(jsonEncode(taskss));
    notifyListeners();
    return images;
  }

  Future<List<taskImage>?> readId(int id) async {
    // completeTasks = await _taskDbController.read2();
    imageId = await _imageDbController.readTaskId(id);
    print('here');
    print(jsonEncode(imageId));
    notifyListeners();
    return imageId;
  }

  Future<bool> delete(int id) async {

    print("delete id image>>$id");
    bool deleted = await _imageDbController.delete(id);

    int index = imageId.indexWhere((element) => element.id == id);
    if (index != -1) {
      imageId.removeAt(index);
       //read();
      notifyListeners();
      print('del true');

      return true;
    }
    notifyListeners();

    print('del false');
    return false;
  }
}
