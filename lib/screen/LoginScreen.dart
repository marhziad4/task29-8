import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/controller/UserApiController.dart';
import 'package:todo_emp/data/DbProvider.dart';
import 'package:todo_emp/model/users.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/UserProvider.dart';
import 'package:todo_emp/responsive/size_config.dart';
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

  // String? token = '';
  String? longitude;
  String? latitude;
  ConnectivityResult? _connectivityResult;
  late StreamSubscription _connectivitySubscription;
  bool? _isConnectionSuccessful;

  @override
  void initState() {
    super.initState();
    // TaskApiController().getTasks(context: context);
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print('Current connectivity status: $result');
      setState(() {
        _connectivityResult = result;
      });
    });
    // location();
    _userNum = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();

    _userNum.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().designWidth(4.14).designHeight(8.96).init(context);
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
              // margin: EdgeInsets.symmetric(horizontal:40, vertical: 160),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig().scaleWidth(20),
                  vertical: SizeConfig().scaleHeight(90)),
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

                        // performLogin();
                         _checkConnectivityState();
                        //  Navigator.pushNamed(context, '/TodoMainPage');
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                        height: SizeConfig().scaleHeight(60),
                        width: SizeConfig().scaleWidth(900),
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
                    // ElevatedButton(
                    //   onPressed: () {
                    //     DbProvider().backup();
                    //   },
                    //   child: const Text('Copy DB'),
                    // ),
                    //
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     DbProvider().backup();
                    //   },
                    //   child: const Text('Restore DB'),
                    // ),
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
    // bool loogedIn = await UserApiController().login(
    //     context: context,
    //     email: _userNum.text,
    //     password: _password.text);

    if (status) {
      debugPrint("here token send to server ===> ${UserPreferences().token}");
      debugPrint("here save IdUser ===> ${UserPreferences().IdUser}");
      Navigator.pushReplacementNamed(context, '/TodoMainPage');

      // setState(() {
      //   visible = true;
      // });
    } else {
      setState(() {
        visible = true;
      });
    }
  }

  //
  // Future<void> save() async {
  //   bool saved = await Provider.of<UserProvider>(context, listen: false)
  //       .addUser(user: user);
  //   if (saved) {
  //     print('تم الاضافة بنجاح');
  //     showSnackBar(context: context, content: 'تم الاضافة بنجاح', error: false);
  //     Navigator.pushReplacementNamed(context, '/TodoMainPage');
  //   } else {
  //     print('لم تتم الاضافة بنجاح');
  //     showSnackBar(
  //         context: context, content: 'لم تتم الاضافة بنجاح', error: true);
  //   }
  // }

  // Future<List<LatLng>> getListMarker() async {
  //   List<LatLng> maps = <LatLng>[];
  //   await _firebaseFirestore.collection("RealState").get().then((value) {
  //     for (int i = 0; i < value.docs.length; i++) {
  //       double lat = double.parse(value.docs[i]
  //           .get('mapRealState')
  //           .substring(0, value.docs[i].get('mapRealState').indexOf(',')));
  //
  //       double lng = double.parse(value.docs[i]
  //           .get('mapRealState')
  //           .substring(value.docs[i].get('mapRealState').indexOf(',') + 1));
  //
  //       debugPrint("we are in get latLng Firebase $lat$lng");
  //
  //       LatLng latLng = LatLng(lat, lng);
  //       maps.add(latLng);
  //     }
  //   });
  //   return maps;
  // }
  // Future<void> location() async {
  //   final cron = Cron();
  //   cron.schedule(Schedule.parse('*/1 * * * *'), () async {
  //     final position = await CurrentLocation.fetch();
  //      latitude=(position.latitude).toString();
  //      longitude=(position.longitude).toString();
  //   await Provider.of<LocationProvider>(context, listen: false)
  //         .addLocation(location: locationUser);
  //     print('every one minutes latitude ${position.latitude}');
  //     print('every one minutes longitude ${position.longitude}');
  //     // TaskProvider.postUpdateDriverLocarionRequset(
  //     //     latitude: position.latitude, longitude: position.longitude);
  //     // bool saved = await Provider.of<UserProvider>(context, listen: false)
  //     //     .addLocation(location: locationUser);
  //   });
  //
  // }
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
      showSnackBar(
          context: context, content: "  لا يوجد اتصال بالانترنت ", error: true);
      print('Not connected to any network');

      setState(() {
        visible = true;
      });

      return false;
    }

    setState(() {
      _connectivityResult = result;
    });
  }

  User get user {
    User user = User();
    // user.title= _titleTextController.text;
    user.email = _userNum.text;
    user.password = _password.text;
    return user;
  }

// Future<void> login() async {
//   if (checkData()) {
//     bool status = await UserApiController().login(
//         context: context,
//         phone: _phone.text.trim(),
//         password: _password.text.trim(),
//         deviceToken: token!);
//     if (status) {
//       debugPrint("here token send to server ===> $token");
//       debugPrint("here status send to server ===> $status");
//
//       setState(() {
//         visible = true;
//       });
//     } else {
//       setState(() {
//         visible = true;
//       });
//     }
//   }
// }

}
