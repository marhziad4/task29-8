import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/data/DbProvider.dart';
import 'package:todo_emp/model/location.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/UserProvider.dart';
import 'package:todo_emp/providers/images_provider.dart';
import 'package:todo_emp/providers/location_provider.dart';
import 'package:todo_emp/providers/task_api_provider.dart';
import 'package:todo_emp/screen/CalendarScreen.dart';
import 'package:todo_emp/screen/LoginScreen.dart';
import 'package:todo_emp/screen/ProfileScreen.dart';
import 'package:todo_emp/screen/SplachScreen.dart';
import 'package:todo_emp/screen/to_do_ui/AllTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/DetailsApiTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/control/NewTaskScreen.dart';
import 'package:todo_emp/screen/to_do_ui/TodoMainPage.dart';
import 'model/taskModel.dart';

String? longitude;
String? latitude;
List<Location>? locations;
List<Location>? locationsById;
bool status = true;
List<Location>? lastLocations;
List<Location>? totalDistance;
List<double>? listDistance;
// List<taskModel>? tasks;
// List<taskModel>? completeTasks ;
// List<taskModel>? asyncTasks;
List<Location>? Location1;
late int task_id;
// taskModel get taskss {
//   taskModel task = taskModel();
//   task.title = Provider.of<TaskProvider>(context).details.text;
//   task.description = _descriptionTextController.text;
//   task.status = status ;
//   task.isDeleted = false ;
//   // task.date = _dateTextController.text;
//   // task.time = _timeTextController.text;
//   // task.isComplete=false;
//   task.date = _dateTextController.text.toString();
//   task.time = _timeTextController.text.toString();
//   task.details = Provider.of<TaskProvider>(context).details.text ;
//   return task;
// }
// Future getCurrentLocation() async {
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission != PermissionStatus.granted) {
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission != PermissionStatus.granted) getLocation();
//     return;
//   }
//   getLocation();
// }
//
// void getLocation() async {
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   debugPrint('position.latitude${position.latitude}');
// }
// late var position ;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbProvider().initDatabase();
  await UserPreferences().initPreferences();
   final position = await CurrentLocation.fetch();
  latitude = (position.latitude).toString();
  longitude = (position.longitude).toString();
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(create: (_) => TaskProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
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
      child: MyMaterialApp(),
    ),
  );
}

void readLocation() async {
print('readLocation');

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
        print('every one minutes2');

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
                lastLocations![0].longitude == longitude.toString()) ||
            distanceInMeters <= 10) {
          lastLocations![0].updatetime = DateTime.now().toString();
          await LocationProvider().update(location: lastLocations![0]);
          print('nothing todo');
        } else
          await LocationProvider().addLocation(location: locationUser);
      } else
        await LocationProvider().addLocation(location: locationUser);

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
        'index ${i} location ${locations![i].latitude} longitude ${locations![i].longitude}  time ${locations![i].time}  updatetime ${locations![i].updatetime}task_id ${locations![i].task_id}');
  }
}

Location get locationUser {
  Location location = Location();
  //location.id = null;
  location.longitude = longitude.toString();
  location.latitude = latitude.toString();
  location.time;
  location.task_id = task_id;
  location.users_id = UserPreferences().IdUser;

  return location;
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<TaskProvider>(create: (_) => TaskProvider()),
//         ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
//         ChangeNotifierProvider<LocationProvider>(
//             create: (_) => LocationProvider()),
//         ChangeNotifierProvider<TasksApiProvider>(
//             create: (_) => TasksApiProvider()),
//
//       ],
//       builder: (BuildContext context, Widget? child) {
//         return MyMaterialApp();
//       },
//     );
//   }
// }

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
        home: TodoMainPage(),
        initialRoute: '/Launch_screen',
        routes: {
          '/Launch_screen': (context) => SplachScreen(),
          '/Login_screen': (context) => LoginScreen(),
          '/New_Task_screen': (context) => NewTaskScreen(),
          // '/Map_screen': (context) => MapScreen(task),
          '/details_apiTasks_screen': (context) => DetailsApiTasksScreen(),
          '/TodoMainPage': (context) => TodoMainPage(),
          '/profile_screen': (context) => ProfileScreen(),
          '/NewTaskScreen': (context) => NewTaskScreen(),
          '/CalenderScreen': (context) => CalenderScreen(),
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

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //false
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

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

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
//cron.schedule(
// Schedule.parse(
// '*/2 * * * *'),
// () async {
// readLocation();
// print('open');
// print(task.status);
// });
//
// TaskProvider()
//     .update(task: tasks[i]);
// status = tasks[i].status;

// GeoCode geoCode = GeoCode();
//
// try {
//   Address coordinates = await geoCode.reverseGeocoding(latitude: 31.4908867,longitude:34.4472317);
//
//   print("Latitude1: ${coordinates}");
//   // print("Longitude1: ${coordinates.longitude}");
// } catch (e) {
//   print('Latitude1 $e');
// }
//   Latitude1: GEOCODE: elevation=44.0, timezone=Asia/Gaza, geoNumber=8438465606587,
// streetNumber=null, streetAddress=Totah, city=Gaza, countryCode=PS,
// countryName=Palestinian Territory, region=Gaza, PS, postal=972, distance=0.154

// TaskProvider.postUpdateDriverLocarionRequset(
//     latitude: position.latitude, longitude: position.longitude);
// bool saved = await Provider.of<UserProvider>(context, listen: false)
//     .addLocation(location: locationUser);

// StreamSubscription<ServiceStatus> serviceStatusStream =
// Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
//   print(status);
// });
//
// getLocationUpdates() {
//   final LocationSettings locationSettings =
//   LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 0);
//
//   StreamSubscription<ServiceStatus> serviceStatusStream =
//   Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
//     print(status);
//   });
// }
//_______________________________________________________
// tasks =await TaskProvider().read();
// completeTasks =await TaskProvider().read2();

// StreamSubscription<ServiceStatus> serviceStatusStream =
// Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
//   print(status);
// });
//

// tasks =
// (await TaskProvider().read())!;
// completeTasks =
// (await TaskProvider().read2())!;
//_________________________________________________________________
//destinase
// var p = 0.017453292519943295;
// var a = 0.5 -
//     cos((double.parse('${lastLocations![0].latitude}') -
//                 double.parse('${latitude.toString()}')) *
//             p) /
//         2 +
//     cos((double.parse('${lastLocations![0].latitude}') * p) *
//             cos(double.parse('${latitude.toString()}') * p) *
//             (1 -
//                 cos((double.parse('${longitude.toString()}') -
//                     (double.parse('${lastLocations![0].longitude}')) *
//                         p)))) /
//         2;
// print('distance2: ${12742 * asin(sqrt(a))}');
// return 12742 * asin(sqrt(a));
// GeoCode geoCode = GeoCode();
//
// try {
//   Address coordinates = await geoCode.reverseGeocoding(latitude: 31.4908867,longitude:34.4472317);
//
//   print("Latitude1: ${coordinates}");
//   // print("Longitude1: ${coordinates.longitude}");
// } catch (e) {
//   print('Latitude1 $e');
// }
//   Latitude1: GEOCODE: elevation=44.0, timezone=Asia/Gaza, geoNumber=8438465606587,
// streetNumber=null, streetAddress=Totah, city=Gaza, countryCode=PS,
// countryName=Palestinian Territory, region=Gaza, PS, postal=972, distance=0.154
//________________________________________________________
/*void customCronJob() {
 Timer? timer;
  timer = Timer.periodic(Duration(seconds: 10), (Timer t) => readLocation());
}*/
//___________________________________________
// TaskProvider().show();
// getCurrentLocation();
// await LocationProvider().addLocation(location: locationUser);
// tasks=await TaskProvider().read();
// completeTasks=await TaskProvider().read2();

// getDistanceFromGPSPointsInRoute(locations);
//customCronJob();

// for (int i = 0; i < locations!.length; i++) {
//   print(
//       'index ${i} location ${locations![i].latitude}  time ${locations![i].time}  updatetime ${locations![i].updatetime}');
// }
