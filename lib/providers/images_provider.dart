
import 'package:flutter/material.dart';
import 'package:todo_emp/controller/ImageDbController.dart';
import 'package:todo_emp/model/taskImage.dart';

class ImagesProvider extends ChangeNotifier {
  ImageDbController _imageDbController = ImageDbController();

  List<taskImage> images = [];
  List<taskImage> imageId = [];
  Future<bool> create({required taskImage image}) async {
    //  taskModel task = taskModel()
    int id = await _imageDbController.create(image);
    images.add(image);
    imageId.add(image);
    print('ImagesProvider');
    notifyListeners();
    return true;

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
    imageId = await _imageDbController.readId(id);

    // print(jsonEncode(completeTasks));
    // print(jsonEncode(taskss));
    notifyListeners();
    return imageId;
  }
  Future<bool> delete(int id) async {
    bool deleted = await _imageDbController.delete(id);

    int index = imageId.indexWhere((element) => element.id == id);
    if (index != -1) {
      //completeTasks.removeAt(index);
      // readAll();
      notifyListeners();
      return true;
    }
    return false;
  }
}
