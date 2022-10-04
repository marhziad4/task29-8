import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_emp/model/login.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._();
  late final SharedPreferences _sharedPreferences;

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._();

  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
  //       UserPreferences().setPlace(latLng.latitude.toString() +

  Future<bool> save(loginUser token) async {
    bool login=await _sharedPreferences.setBool('logged_in', true);
    return login;
  }
  Future<void> setToken(String token) async {
    await _sharedPreferences.setString('token', token);
  }
  Future<void> setname(String name) async {
    await _sharedPreferences.setString('name', name);
  }
  Future<void> setimage(String image) async {
    await _sharedPreferences.setString('image', image);
  }
  Future<void> setIdUser(String IdUser) async {
    await _sharedPreferences.setString('IdUser', IdUser);
  }

  Future<void>setChek(String chek) async {
    await _sharedPreferences.setString('chek', chek);
  }
  String get token => _sharedPreferences.getString('token') ?? '';
  String get IdUser => _sharedPreferences.getString('IdUser') ?? '';
  String get chek => _sharedPreferences.getString('chek') ?? 'false';
  String get name => _sharedPreferences.getString('name') ?? '';
  String get image => _sharedPreferences.getString('image') ?? '';

  bool? get isLoggedIn => _sharedPreferences.getBool('logged_in')??false;
  Future<void> setPlace(String place) async {
    await _sharedPreferences.setString('place', place);
  }

  String getPlace() {
    return _sharedPreferences.getString('place') ?? '';
  }
  Future<bool> logout() async {
    print('UserPreferences');
    return await _sharedPreferences.clear();
  }
}
