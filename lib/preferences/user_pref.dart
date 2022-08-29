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

  Future<void> save(loginUser token) async {
    await _sharedPreferences.setBool('logged_in', true);
  }
  Future<void> setToken(String token) async {
    await _sharedPreferences.setString('token', token);
  }
  Future<void> setIdUser(String IdUser) async {
    await _sharedPreferences.setString('IdUser', IdUser);
  }

  Future<bool>setChek(bool chek) async {
   return await _sharedPreferences.setBool('chek', chek);
  }
  String get token => _sharedPreferences.getString('token') ?? '';
  String get IdUser => _sharedPreferences.getString('IdUser') ?? '';
  bool? get chek => _sharedPreferences.getBool('chek') ?? false;

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
