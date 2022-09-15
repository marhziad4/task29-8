class Location {
   int? id;
  String ? users_id;
  int? task_id;
  String? latitude='0';
  String? longitude='0';
  String? time = DateTime.now().toString();
  String? updatetime = DateTime.now().toString();
  //DateTime
  Location();
  Location.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    users_id = map['users_id'];
    task_id = map['task_id'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    time = map['time'];
    updatetime = map['updatetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users_id'] = this.users_id;
    data['task_id'] = this.task_id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['time'] = this.time;
    data['updatetime'] = this.updatetime;

    return data;
  }
  Location.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    users_id = map['users_id'];
    task_id = map['task_id'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    time = map['time'];
    updatetime = map['updatetime'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users_id'] = this.users_id;
    data['task_id'] = this.task_id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['time'] = this.time;
    data['updatetime'] = this.updatetime;

    return data;
  }

  Map<String, dynamic> toMap1() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['users_id'] = this.users_id;
    data['id'] = this.id;
    data['updatetime'] = this.updatetime;
    return data;
  }
}
