class apiTask {
  int? id;
  String? title;
  String? description;
  int? userId;
  String? createdAt;
  String? updatedAt;

  apiTask(
      {this.id,
        this.title,
        this.description,
        this.userId,
        this.createdAt,
        this.updatedAt});

  apiTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}