import 'package:flutter/material.dart';
import 'package:todo_emp/preferences/user_pref.dart';

class SplachScreen extends StatefulWidget {
  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 2)).then((v) {
      //UserPreferences().isLoggedIn != null &&
      if (UserPreferences().isLoggedIn == true) {
        print(UserPreferences().isLoggedIn);
        Navigator.pushReplacementNamed(context, '/TodoMainPage');

        print(UserPreferences().isLoggedIn);
      } else {
        Navigator.pushReplacementNamed(context, '/Login_screen');

        print(UserPreferences().isLoggedIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image(
        image: AssetImage('assets/images/landlogo.jpg'),
      )),
    );
  }
}
