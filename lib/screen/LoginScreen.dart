import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:todo_emp/controller/UserApiController.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/utils/helpers.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading2.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {
  late TextEditingController _userNum;
  late TextEditingController _password;
  bool _passwordVisible = true;
  late bool visible = true;
  String? longitude;
  String? latitude;

  @override
  void initState() {
    super.initState();
    _userNum = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _userNum.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 90),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك !',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                    ),
                    Text(
                      'الرجاء ادخال الحساب',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey.shade500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextField1(
                      controller: _userNum,
                      textInputType: TextInputType.number,
                      hint: 'ادخل رقم المستخدم',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color(0XFFF303030).withOpacity(.50),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextField1(
                      controller: _password,
                      obscure: _passwordVisible,
                      textInputType: TextInputType.number,
                      maxLines: 1,
                      minLines: 1,
                      hint: 'ادخل كلمة المرور',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0XFFF303030).withOpacity(.50),
                      ),
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0XFF303030).withOpacity(.50),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        visible = true;

                        _checkConnectivityState();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                        height: 60,
                        width: 900,
                        child: visible
                            ? Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              )
                            : const Loading2(),
                        decoration: BoxDecoration(
                            color: Color(0xff1A6FD1),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ]),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  Future performLogin() async {
    if (chekData()) {
      await login();
    }
  }

  bool chekData() {
    if (_userNum.text.isNotEmpty && _password.text.isNotEmpty) {
      setState(() {
        visible = false;
      });
      return true;
    } else {
      showSnackBar(
          context: context, content: "   يرجى ادخال البيانات ! ", error: true);
      setState(() {
        visible = true;
      });
      return false;
    }
  }

  Future login() async {
    bool status = await UserApiController().login(
        context: context,
        username: _userNum.text.trim(),
        password: _password.text.trim());
    UserPreferences().setIdUser(_userNum.text);

    if (status) {
      debugPrint("here token send to server ===> ${UserPreferences().token}");
      debugPrint("here save IdUser ===> ${UserPreferences().IdUser}");
      // bool login =UserPreferences().save(token) ;
      if (UserPreferences().isLoggedIn == false) {
        Navigator.pushReplacementNamed(context, '/Login_screen');
        print('false login');
      } else
        Navigator.pushReplacementNamed(context, '/TodoMainPage');
    } else {
      setState(() {
        visible = true;
      });
    }
  }

  Future<bool> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      performLogin();
      print('Connected to a Wi-Fi network');
      return true;
    } else if (result == ConnectivityResult.mobile) {
      performLogin();
      print('Connected to a mobile network');
      return true;
    } else {
      context.showFlashDialog(
        persistent: true,
        title: Text('خطأ'),
        content: Text('تعذر الاتصال بالانترنت '),
      );
      print('Not connected to any network');

      setState(() {
        visible = true;
      });

      return false;
    }
  }
}
