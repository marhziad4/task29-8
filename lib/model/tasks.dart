class Tasks {
  int? id;
  String? title;
  String? description;
  int? done;
  String? start_date;
  String ? end_date;
  int? status;
  // int? userId;
  int? create_user;
  int? update_user;
  int? priority;
  int? create_dept;
  int? to_dept;
  String ? userId;
Tasks();
  Tasks.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    description = json['description'];
    done = json['done'];
    start_date = json['start_date'];
    end_date = json['end_date'];
    status = json['status'];
    // userId = json['user_id'];
    create_user = json['create_user'];
    update_user = json['update_user'];
    priority = json['priority'];
    create_dept = json['create_dept'];
    to_dept = json['to_dept'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['done'] = this.done;
    data['start_date'] = this.start_date;
    data['end_date'] = this.end_date;
    data['status'] = this.status;
    // data['user_id'] = this.userId;
    data['create_user'] = this.create_user;
    data['update_user'] = this.update_user;
    data['priority'] = this.priority;
    data['create_dept'] = this.create_dept;
    data['to_dept'] = this.to_dept;
    return data;
  }
}
