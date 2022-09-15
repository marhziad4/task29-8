class taskImage {
    int? id;
  late String image;
  late int task_id;

  taskImage();

  taskImage.fromJson(Map<dynamic, dynamic> rowMap) {
    this.id = rowMap['id'];
    this.image = rowMap['image'];
    this.task_id = rowMap['task_id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
     map['id'] = this.id;
    map['image'] = this.image;
    map['task_id'] = this.task_id;

    return map;
  }

   Map<String, dynamic> toJsonNoId() {
     Map<String, dynamic> map = Map<String, dynamic>();
     map['image'] = this.image;
     map['task_id'] = this.task_id;

     return map;
   }
}
