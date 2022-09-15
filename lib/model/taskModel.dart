import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lit_backup_service/lit_backup_service.dart';
import 'package:todo_emp/preferences/user_pref.dart';

// List<taskModel> taskFromJson(String str) =>
//     List<taskModel>.from(json.decode(str).map((x) => taskModel.fromJson(x)));
//

class taskModel implements BackupModel {
   int? id;
  late String userId;
  late String chek;

  late String title;
  late String description;
  String time = TimeOfDay.now().toString();
  late String date = DateTime.now().toString();
   String ?details;

  String? image;
  int status = 0;
  int? isDeleted = 0;

  // bool async = false;
  int counter = 0;
  int async = 0;

  // late bool isComplete

  // late int users_id;
  // DateTime time_created = DateTime.now();
  // late bool isComplete;
  // taskModel({required this.id,required this.title,required this.description,required this.time,required this.time});
  // taskModel({required String title});
  taskModel();

  taskModel.fromJson(Map<dynamic, dynamic> rowMap) {
    this.id = rowMap['id'];
    this.userId = rowMap['userId'];
    this.title = rowMap['title'];
    this.description = rowMap['description'];
    this.time = rowMap['time'];
    this.date = rowMap['date'];
    this.details = rowMap['details'];
    this.image = rowMap['image'];
    this.counter = rowMap['counter'];
    this.async = rowMap['async'];
    this.status = rowMap['status'];
    // this.status = rowMap['status'] == 1 ? true : false;
    this.isDeleted = rowMap['isDeleted'];
    this.chek = rowMap['chek'];

    // time_created = rowMap["time_created"].toDate();
    // this.isComplete = rowMap['isComplete'] == 1 ? true : false;

    // users_id = rowMap['users_id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['userId'] = this.userId;
    map['description'] = this.description;
    map['time'] = this.time;
    map['date'] = this.date;
    map['details'] = this.details;
    map['image'] = this.image;
    map['status'] = this.status;
    map['counter'] = this.counter;
    map['async'] = this.async;
    map['chek'] = this.chek;
    // map['status'] = this.status ? 1 : 0;    // map['users_id'] = users_id;
    map['isDeleted'] = this.isDeleted; // map['users_id'] = users_id;
    // map['chek'] = this.chek ? 1 : 0;    // map['users_id'] = users_id;
    // map['async'] = this.async ? 1 : 0;    // map['users_id'] = users_id;
    // map["time_created"] = time_created;
    // map["isComplete"] = this.isComplete ? 1 : 0;
    return map;
  }

  Map<String, dynamic> toMap1() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['details'] = this.details;
    // map['image'] = this.image;

    return map;
  }
}
