import 'package:todo_emp/model/taskModel.dart';

class BaseResponse {

  late List<taskModel> data;

  BaseResponse.fromJson(Map<String, dynamic> json) {

    if (json['list'] != null) {
      data = <taskModel>[];
      json['list'].forEach((v) {
        data.add(new taskModel.fromJson(v));
      });
    }
  }
}