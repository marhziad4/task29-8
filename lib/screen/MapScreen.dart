import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:todo_emp/model/location.dart';
import 'package:todo_emp/model/taskImage.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/main.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/images_provider.dart';
import 'package:todo_emp/providers/location_provider.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/app_button_main.dart';
import 'package:todo_emp/widgets/app_text_field.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  final taskModel task;

  MapScreen(this.task);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with Helpers {
  final Set<Polyline> _polyline = {};
  List<Marker> _marker = [];
  List<Marker> _list = [];
  late GoogleMapController _googleMapController;
  late CameraPosition _cameraPosition;
  late GoogleMap googleMap;
  int x = 0;

  late Position position;
  final ImagePicker imagePicker = ImagePicker();
  late String addressLocation;
  late String country;
  late String cl;
  late LatLng? latlong = null;
  var address;
  var firstAddress;
  var tapped;
  late TextEditingController details;


  /////polyLine///////
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBFkWp36uH86gss_Wt-32YNSKjXk-UFBqM";
  late double panelHeighOpen;

  late double panelHeighClosed;

  /////polyLine///////
void location()async{
  locationsById = await Provider.of<LocationProvider>(context, listen: false)
      .readByTask(taskId);
  ImagesById = await Provider.of<ImagesProvider>(context, listen: false)
      .readId(taskId);
  setState(() {
    _marker.addAll(_list);
   // addMarker();
  });
  Future.delayed(Duration(minutes: 1)).then((v) {
    addMarker();
  });
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addMarker();
 //   location();
    taskId = widget.task.id!;
    Provider.of<LocationProvider>(context, listen: false).readByTask(taskId);
    _cameraPosition =
        CameraPosition(target: LatLng(31.520088, 34.4347784), zoom: 11);
    details = TextEditingController(text: widget.task.details);
    _getPolyline();


    print(_marker);
  }

  @override
  void dispose() {
   // _googleMapController.dispose();
    details.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    panelHeighOpen = MediaQuery.of(context).size.height * 0.8;
    panelHeighClosed = MediaQuery.of(context).size.height * 0.2;

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          'تحديد موقع',
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () async {
                // _getFromCamera();
                pickImageCamera();
              },
              icon: Icon(
                Icons.camera_alt,
                size: 40,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        backgroundColor: Color(0xffffffff),
        iconTheme: IconThemeData(color: Color(0xff0f31dc)),
      ),
      body: Consumer<ImagesProvider>(builder: (
        BuildContext context,
        ImagesProvider provider,
        Widget? child,
      ) {
        return SlidingUpPanel(
          minHeight: panelHeighClosed,
          maxHeight: panelHeighOpen,
          parallaxOffset: .5,
          parallaxEnabled: true,
          panel: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  padding: EdgeInsets.only(right: 5),
                  child: Column(
                    children: [
                      Text(
                        widget.task.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 200),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AppTextField1(
                        hint: "تفاصيل",
                        controller: details,
                        maxLines: 5,
                        minLines: 1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AppButtonMain(
                        onPressed: () async {
                           await Provider.of<TaskProvider>(context,
                                   listen: false)
                               .update(task: task);
                           locations = await Provider.of<LocationProvider>(
                                   context,
                                   listen: false)
                               .read();
                          // for (int i = 0; i < locations!.length; i++) {
                          //   print(
                          //       'index ${i} location ${locations![i].latitude} longitude ${locations![i].longitude}  time ${locations![i].time}  updatetime ${locations![i].updatetime}task_id ${locations![i].task_id}');
                          // }


                          Navigator.pop(context);
                        },
                        title: 'حفظ',
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          child: provider.imageId.length != 0
                              ? Container(
                                  width: double.infinity,
                                  height: 220,
                                  child: ListView.builder(
                                      //  shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: provider.imageId.length,
                                      itemBuilder: (context, index) {
                                        taskImage Imagetask =
                                            provider.imageId[index];

                                        return Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                Scaffold(
                                                                  body: Center(
                                                                    child: Hero(
                                                                      tag:
                                                                          '2121',
                                                                      child: Image
                                                                          .file(
                                                                              File('/storage/emulated/0/Pictures/pla_todo/${provider.imageId.toList()[index].image}')),
                                                                    ),
                                                                  ),
                                                                )));
                                              },
                                              child: Container(
                                                width: 130,
                                                height: 170,
                                                child: Image.file(File(
                                                    '/storage/emulated/0/Pictures/pla_todo/${provider.imageId.toList()[index].image}')),
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.cancel_outlined,
                                                  size: 25.0,
                                                ),
                                                color:
                                                    Colors.white, //<-- SEE HERE

                                                onPressed: () async {
                                                  await Provider.of<
                                                              ImagesProvider>(
                                                          context,
                                                          listen: false)
                                                      .delete(provider.imageId
                                                          .toList()[index]
                                                          .id!);
                                                }),
                                          ],
                                        );
                                      }),
                                )
                              : Container(
                                  width: 20,
                                  height: 20,
                                  child: Text(''),
                                )),

                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 650,
                width: 700,
                child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  indoorViewEnabled: true,
                  buildingsEnabled: true,
                  trafficEnabled: true,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  polylines: Set<Polyline>.of(polylines.values),
                  initialCameraPosition: _cameraPosition,
                  zoomGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                  onCameraMove:(CameraPosition cameraPosition){
                    print(cameraPosition.zoom);
                  },
                  onTap: (LatLng latLng) async {
                    _googleMapController.animateCamera(
                        CameraUpdate.newLatLng(latLng));
                  },
                  onMapCreated:(controller){
                    if (!mounted) {
                      return;
                    }
                    setState(() {
              _googleMapController=controller;
                    });
                    // addMarker();
                    // setState(() { });
                  },
                  markers: Set<Marker>.of(_marker),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),

          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        );
      }),
    );
  }



  void addMarker() {

    for (int i = 0; i < locationsById!.length; i++) {
      if (locationsById![i].task_id == widget.task.id) {
        // LatLng latlng;
        // latlng = LatLng(double.parse('${locations![i].latitude}'),
        //     double.parse('${locations![i].longitude}'));
        // print(
        //     'Marker >> latitude :${locationsById![i].latitude} longitude:${locationsById![i].longitude}task_idmark:${locationsById![i].task_id}');

          // locationsById =  LocationProvider().readByTask(taskId);
          for (int i = 0; i < locationsById!.length; i++) {
            // print('length${locationsById!.length}');
            LatLng latlng = LatLng(
                double.parse('${locationsById![i].latitude}'),
                double.parse('${locationsById![i].longitude}'));

            // print(
            //     'Marker1 >> latitude :${locationsById![i].latitude} longitude:${locationsById![i].longitude} time:${locationsById![i].time} updatetime:${locationsById![i].updatetime}task_id:${locationsById![i].task_id}');

            _marker.add(
              Marker(
                markerId: MarkerId([i].toString()),
                position: LatLng(double.parse('${locationsById![i].latitude}'),
                    double.parse('${locationsById![i].longitude}')),
                // infoWindow: InfoWindow(title: "Marker1",snippet: "Marker",onTap: (){
                //   Navigator.pushReplacementNamed(context, '/TodoMainPage');
                //
                // }),
                //   icon:BitmapDescriptor.defaultMarker,

                infoWindow: InfoWindow(
                    // title:'${distanceInMeters}',

                    title: '${[
                      i
                    ]} ',
                    snippet: locationsById![i].time),
              ),
            );
          }

      }
    }
    location();

}

  Uint8List? imageRaw;
  String? photoName;
  File? FileImage;
  File? FileImage2;

//,imageQuality: 25
  Future<void> pickImageCamera() async {
    print('FileImage');
    var photo = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 25);
    FileImage = File(photo!.path);
    print(FileImage);
    new File('/storage/emulated/0/Pictures/pla_todo/${photo.name}')
        .create(recursive: true);
    print('file');
    FileImage2 = await FileImage!
        .copy('/storage/emulated/0/Pictures/pla_todo/${photo.name}');
    print(FileImage2);
    if (!mounted) {
      return;
    }
    setState(() {
      // GallerySaver.saveImage(photo.path, albumName: 'pla_todo'); //
      print('pla_todo');
      photoName = photo.name;
      print(photo.name);
    });

    bool saved = await Provider.of<ImagesProvider>(context, listen: false)
        .create(image: images);
    await Provider.of<ImagesProvider>(context, listen: false).readId(taskId);
    location();
    ///_______________position_________________
    final position = await CurrentLocation.fetch();
    latitude = (position.latitude).toString();
    longitude = (position.longitude).toString();
    await LocationProvider().addLocation(location: locationUser);
    setState(() {
      void llocation()async {
        locationsById =
        await Provider.of<LocationProvider>(context, listen: false)
            .readByTask(taskId);
      }
      location();

    });

    ///_______________________________________

    if (saved) {
      await Provider.of<ImagesProvider>(context, listen: false).readId(taskId);
      locationsById = await Provider.of<LocationProvider>(context, listen: false)
          .readByTask(taskId);
      showSnackBar(
          context: context, content: 'تمت العملية بنجاح', error: false);
    } else {
      showSnackBar(
          context: context,
          content: 'لا يجوز تحميل اكثر من 3 صور',
          error: true);
    }

    setState(() {});
  }

  /// Get from Camera
  late String imgString;

  _getPolyline() async {
    locations = await LocationProvider().read();
    lastLocations = await LocationProvider().lastRow();

    for (int i = 0; i < locationsById!.length; i++) {
      polylineCoordinates.add(LatLng(
          double.parse('${locationsById![i].latitude}'),
          double.parse('${locationsById![i].longitude}')));
    }

    _addPolyLine();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 3,
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  taskModel get task {
    taskModel task = widget.task;
    task.details = details.text;
    return task;
  }

  taskImage get images {
    taskImage images = taskImage();
    images.image = photoName.toString();
    images.task_id = taskId;

    return images;
  }

  Location get locationUser {
    Location location = Location();
    location.longitude = longitude.toString();
    location.latitude = latitude.toString();
    location.time;
    location.task_id = taskId;
    location.users_id = UserPreferences().IdUser;
    location.image_id = image_Id;

    return location;
  }
}
