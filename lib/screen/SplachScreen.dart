import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/router.dart';
import 'package:todo_emp/screen/to_do_ui/TodoMainPage.dart';

class SplachScreen extends StatefulWidget {
  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  // NavigationFunction(context) async {
  //   await Future.delayed(Duration(seconds: 3));
  //   RouterClass.routerClass.pushToSpecificScreenUsingWidget(TodoMainPage());
  // }
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   NavigationFunction(context);
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 2)).then((v) {
      if(UserPreferences().isLoggedIn != null &&UserPreferences().isLoggedIn == true){
       print(UserPreferences().isLoggedIn);
        Navigator.pushReplacementNamed(context, '/TodoMainPage' );
      }else{
        Navigator.pushReplacementNamed(context, '/Login_screen' );
        print(UserPreferences().isLoggedIn);

      }

    });
  }

  @override
  Widget build(BuildContext context) {
    // NavigationFunction(context);
    // Future.delayed(Duration(seconds: 3)).then((v) {
    //   Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(builder: (context) {
    //     return Page1();
    //   }));
    // });
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

// PointLatLng(double.parse('${locations![0].latitude}'), double.parse('${locations![0].longitude}')),
// getPolyline() async {
//   locations = await LocationProvider().read();
//   for(int i=0;i<=10;i++){
//     print('map ${locations![i].latitude}');
//     polylineCoordinates.add(LatLng(double.parse('${locations![i].latitude}'), double.parse('${locations![i].longitude}')));
//     polylineCoordinates.add(LatLng(31.520088, 34.0442632));
//   }