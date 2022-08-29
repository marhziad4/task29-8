class User {
    int? id;
   // String? fullName;
    String? email;
    String? password;
   // String? mobile;
   // String? jobTitle;
   // String? token;
   // late Location location;

  User();
  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    email = map['email'];
    password = map['password'];
    // mobile = map['mobile'];
    // jobTitle = map['job_title'];
    // token = map['token'];
    // location= Location.fromMap(map['location']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    // data['mobile'] = this.mobile;
    // data['job_title'] = this.jobTitle;

    // data['token'] = this.token;
    // data['location']=this.location;
    return data;
  }

}
// class Location {
//   late double latitude;
//   late double longitude;
//   Location();
//   Location.fromMap(Map map) {
//     this.latitude = map['latitude'];
//     this.longitude = map['longitude'];
//   }
//   Map<String, dynamic> toMap() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     return data;
//   }
// }