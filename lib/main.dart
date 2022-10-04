import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/data/DbProvider.dart';
import 'package:todo_emp/model/location.dart';
import 'package:todo_emp/model/taskImage.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/images_provider.dart';
import 'package:todo_emp/providers/location_provider.dart';
import 'package:todo_emp/providers/task_api_provider.dart';
import 'package:todo_emp/screen/LoginScreen.dart';
import 'package:todo_emp/screen/SplachScreen.dart';
import 'package:todo_emp/screen/to_do_ui/AllTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/control/NewTaskScreen.dart';
import 'package:todo_emp/screen/to_do_ui/TodoMainPage.dart';
import 'model/taskModel.dart';

String? longitude;
String? latitude;
List<Location>? locations;
bool status = true;
List<Location>? lastLocations;

List<Location>? totalDistance;
List<double>? listDistance;
List<Location>? Location1;
late int taskId;

int? image_Id;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbProvider().initDatabase();
  await UserPreferences().initPreferences();
  await CurrentLocation.fetch();
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(create: (_) => TaskProvider()),
        ChangeNotifierProvider<ImagesProvider>(
            create: (context) => ImagesProvider()),
        ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider()),
        ChangeNotifierProvider<TasksApiProvider>(
            create: (_) => TasksApiProvider()),
      ],
      builder: (BuildContext context, Widget? child) {
        return MyMaterialApp();
      },

    ),
  );
}

void readLocation() async {
  print('readLocation');
  Position userLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print('readLocation :$userLocation');
  final position = await CurrentLocation.fetch();
  latitude = (position.latitude).toString();
  longitude = (position.longitude).toString();
  // print('every one minutes latitude ${position.latitude}');
  // print('every one minutes longitude ${position.longitude}');
  lastLocations = await LocationProvider().lastRow();
  // tasks = await TaskProvider().read();

  print('lastLocations${jsonEncode(lastLocations)}');
  List<taskModel>? Tasks;
  Tasks = await TaskProvider().read();

  for (int i = 0; i < Tasks!.length; i++) {
    // print('taskds${jsonEncode(Tasks)}');

    if (Tasks[i].counter == 1) {
      if (lastLocations!.length > 0) {
        print('every one minutes2${Tasks[i].counter}');
        // print(
        //     'latitude >> ${lastLocations![0].latitude} == ${latitude.toString()}');
        // print(
        //     'longitude >> ${lastLocations![0].longitude} == ${longitude.toString()}');

        double distanceInMeters = Geolocator.distanceBetween(
            double.parse('${lastLocations![0].latitude}'),
            double.parse('${lastLocations![0].longitude}'),
            double.parse('${latitude.toString()}'),
            double.parse('${longitude.toString()}'));
        print('distanceInMeters ${distanceInMeters}');
        listDistance?.add(distanceInMeters);

        if ((lastLocations![0].latitude == latitude.toString() &&
                lastLocations![0].longitude == longitude.toString())
            // || distanceInMeters <= 3
            ) {
          lastLocations![0].updatetime = DateTime.now().toString();
          await LocationProvider().update(location: lastLocations![0]);
          print('nothing todo');
        } else
          await LocationProvider().addLocation(location: locationUser);
      } else
        await LocationProvider().addLocation(location: locationUser);
      await LocationProvider().update(location: locationUser);
      //   else{
      //     print('لا يوجد مهام قيد التنفيذ');
      //   }
      //
    }
  }
  // print('material');
  // print('every one minutes latitude ${position.latitude}');
  // print('every one minutes longitude ${position.longitude}');

  locations = await LocationProvider().read();
  for (int i = 0; i < locations!.length; i++) {
    print(
        'index ${i} location ${locations![i].latitude} longitude ${locations![i].longitude}  time ${locations![i].time}  updatetime ${locations![i].updatetime}task_id ${locations![i].task_id}image_id ${locations![i].image_id}');
  }
}

Location get locationUser {
  Location location = Location();
  location.longitude = longitude.toString();
  location.latitude = latitude.toString();
  location.time;
  location.task_id = taskId;
  location.users_id = UserPreferences().IdUser;
  location.image_id = null;

  return location;
}

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        initialRoute: '/Launch_screen',
        routes: {
          '/Launch_screen': (context) => SplachScreen(),
          '/Login_screen': (context) => LoginScreen(),
          '/New_Task_screen': (context) => NewTaskScreen(),
          '/TodoMainPage': (context) => TodoMainPage(),
          '/NewTaskScreen': (context) => NewTaskScreen(),
          '/allTaskScreen': (context) => AllTasksScreen(),
        });
  }
}

class CurrentLocation {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> fetch() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
