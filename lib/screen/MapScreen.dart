import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/main.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/location_provider.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/Utility.dart';
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
  late GoogleMapController googleMapController;
  late CameraPosition _cameraPosition;
  late GoogleMap googleMap;
  //Image imageFile= Image.file(File('/storage/emulated/0/Pictures/pla_todo'));

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

  // _timeTextController = TextEditingController(text: widget.task.time);

  /////polyLine///////
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBFkWp36uH86gss_Wt-32YNSKjXk-UFBqM";

  /////polyLine///////
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // listMarker();
    _cameraPosition =
        CameraPosition(target: LatLng(31.520088, 34.4347784), zoom: 11);
    details = TextEditingController(text: widget.task.details);
    _getPolyline();
    _marker.addAll(_list);
    print(_marker);
    //listMarker();
    // _cameraPosition = CameraPosition(target: LatLng(31.568836, 34.564535),
    //   zoom: 5,
    // );

    // googleMap=createMapOptions();
  }

  @override
  void dispose() {
    super.dispose();
    details.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeighOpen = MediaQuery.of(context).size.height * 0.8;
    final panelHeighClosed = MediaQuery.of(context).size.height * 0.2;

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
              onPressed: () {
                // _getFromCamera();
                pickImageCamera();
              },
              icon: Icon(
                Icons.camera_alt,
                size: 40,
              ),
              // onPressed: () async => await requestLocationPremission(),
              // icon: Icon(Icons.location_on),
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
      body: SlidingUpPanel(
        minHeight: panelHeighClosed,
        maxHeight: panelHeighOpen,
        parallaxOffset: .5,
        parallaxEnabled: true,
        panel: Column(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 250),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextField1(hint: "تفاصيل", controller: details),
                  SizedBox(
                    height: 10,
                  ),
                  // widget.task.image
                  // widget.task.image
                  //6ca5e1f6-c582-4575-9611-dd7ad8e442356687349653389249750.jpg
                  //data/user/0/com.example.todo_emp/cache/
                  /*
                    //Image imageFile= Image.file(File('/storage/emulated/0/Pictures/pla_todo'));
                  //'/data/user/0/com.example.todo_emp/cache/${widget.task.image}'
                   */
                  Container(
                      child: widget.task.image != null
                          ? Container(
                        width: 200,
                        height: 200,
                        child: Image.file(File(
                            '/data/user/0/com.example.todo_emp/cache/${widget.task.image}')),
                      )
                          : photoName==null?
                      Text(' ')
                          :
                      Container(
                        width: 200,
                        height: 200,
                        child: Image.file(File(
                            '/data/user/0/com.example.todo_emp/cache/${photoName}')),
                      )
                    /*
                              : Container(
                                    width: 200,
                                    height: 200,
                                    child: Utility.imageFromBase64String(
                                        widget.task.image!),
                                  )
                             */

                  ),


                  SizedBox(
                    height: 10,
                  ),
                  AppButtonMain(
                    onPressed: () async {
                       await Provider.of<TaskProvider>(context, listen: false)
                           .update1(task: task);
                      // TaskDbController().alterTable('TABLE_CUSTOMER', 'Country');
                      Navigator.pop(context);
                    },
                    title: 'حفظ',
                  )
                ],
              ),
            ),
          ],
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
                // liteModeEnabled: true,
                tiltGesturesEnabled: true,
                buildingsEnabled: true,
                trafficEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                polylines: Set<Polyline>.of(polylines.values),
                initialCameraPosition: _cameraPosition,
                onTap: (LatLng latLng) async {
                  // getMarkers1(tapped.latitude, tapped.longitude);

                  //   List<Placemark> placemarks = await placemarkFromCoordinates(
                  //       tapped.latitude, tapped.longitude);
                  //   print(placemarks[0].street);
                  // },
                  // onTap: (LatLng latLng) {
                  //   if (mounted) {
                  //     setState(() {
                  //       UserPreferences().setPlace(latLng.latitude.toString() +
                  //           ',' +
                  //           latLng.longitude.toString());
                  //     });
                  //   }
                  // googleMapController.showMarkerInfoWindow(
                  //     MarkerId('${locations![0].longitude}'));

                  googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                          CameraPosition(target: latLng, zoom: 5)));
                },
                onMapCreated: _onMapCreated,
                // onMapCreated: (GoogleMapController controller) {
                //   // addMarker(LatLng(31.350556, 34.452679));
                //   googleMapController = controller;
                //
                //   // double lat = double.parse(widget.location!
                //   //     .substring(0, widget.location!.indexOf(',')));
                //   // double lng = double.parse(widget.location!
                //   //     .substring(widget.location!.indexOf(',') + 1));
                //
                //   // LatLng latLng = LatLng(lat, lng);
                //   // googleMapController.animateCamera(
                //   //     CameraUpdate.newCameraPosition(
                //   //         CameraPosition(target: latLng, zoom: 15)));
                // },
                markers: Set<Marker>.of(_marker),
                // polylines:_polyline,
              ),
            ),
            // markers: _markers,
            SizedBox(height: 30),
          ],
        ),
        // panelBuilder: ,
        // onPanelSlide: ,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
    );
  }

  // listMarker() async {
  //   locations = await LocationProvider().read();
  //   locationas = await LocationProvider().show(widget.task.id);
  //   for (int i = 0; i < locations!.length; i++) {
  //     if(locations![i].task_id != widget.task.id){
  //
  //       LatLng latlng;
  //     latlng = LatLng(double.parse('${locations![i].latitude}'),
  //         double.parse('${locations![i].longitude}'));
  //     print(
  //         'Marker >> latitude :${locations![i].latitude} longitude:${locations![i].longitude}task_idmark:${locations![i].task_id}');
  //
  //     setState(() {
  //       _list.add(
  //         Marker(
  //           markerId: MarkerId([i].toString()),
  //           position: latlng,
  //         ),
  //       );
  //     });
  //   }
  //   }
  // }

  void _onMapCreated(GoogleMapController controller) async {
    locationas = await LocationProvider().show(widget.task.id);

    setState(() {
      /*
        locations = await LocationProvider().read();
  locationas = await LocationProvider().show(widget.task.id);
  for (int i = 0; i < locations!.length; i++) {
    if(locations![i].task_id != widget.task.id){
      LatLng latlng;
    latlng = LatLng(double.parse('${locations![i].latitude}'),
        double.parse('${locations![i].longitude}'));
    print(
        'Marker >> latitude :${locations![i].latitude} longitude:${locations![i].longitude}task_idmark:${locations![i].task_id}');
    setState(() {
    */

      for (int i = 0; i < locationas!.length; i++) {
        LatLng latlng;
        latlng = LatLng(double.parse('${locationas![i].latitude}'),
            double.parse('${locationas![i].longitude}'));
        print(
            'Marker1 >> latitude :${locations![i].latitude} longitude:${locations![i].longitude} time:${locations![i].time} updatetime:${locations![i].updatetime}task_id:${locationas![i].task_id}');

        _marker.add(
          Marker(
            markerId: MarkerId([i].toString()),
            position: LatLng(double.parse('${locationas![i].latitude}'),
                double.parse('${locationas![i].longitude}')),
            // infoWindow: InfoWindow(title: "Marker1",snippet: "Marker",onTap: (){
            //   Navigator.pushReplacementNamed(context, '/TodoMainPage');
            //
            // }),

            infoWindow: InfoWindow(
                // title:'${distanceInMeters}',

                title: '${[
                  i
                ]} ${locationas![i].latitude}  ${locations![i].longitude} ',
                snippet: locationas![i].time),
            // onTap: () => _onTap(locations),
            draggable: false,

            // icon: locationas![i] == 0
            //     ? BitmapDescriptor.defaultMarkerWithHue(
            //         BitmapDescriptor.hueCyan)
            //     : BitmapDescriptor.defaultMarkerWithHue(
            //         BitmapDescriptor.hueGreen),

            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            // locationas![i]==0 ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)
            //     :BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
      }
// BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      // googleMap=createMapOptions();
    });
  }

  Uint8List? imageRaw;
  String? photoName;
  File? FileImage;
  File? FileImage2;

  Future<void> pickImageCamera() async {
    print('FileImage');
    var photo = await imagePicker.pickImage(source: ImageSource.camera);
    FileImage = File(photo!.path);
    print(FileImage);
    new File('/storage/emulated/0/Pictures1/pla_todo1/${photo.name}').create(recursive: true);
    print('file');
    FileImage2= await FileImage!.copy('/storage/emulated/0/Pictures/pla_todo/${photo.name}');
    print(FileImage2);

    setState(() {

      // GallerySaver.saveImage(photo.path, albumName: 'pla_todo'); //
      print('pla_todo');
      photoName = photo.name;
      print(photo.name);
    });
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++
    //   final ImagePicker _imagePicker = ImagePicker();
    //   PickedFile? _pickedFile;
    /*
    Future pickImage() async {
      _pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
      if (_pickedFile != null) {
        setState(() {});
      }
    }

    Future uploadImage() async {
      if (_pickedFile != null) {
        Provider.of<ImagesProvider>(context, listen: false)
            .uploadImage(context, _pickedFile!.path);
      }
    }
    */
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++


    //data/user/0/com.example.todo_emp/cache/null
    // imageRaw = await FileImage.readAsBytes();

    // pickedImage = (await imagePicker.pickImage(
    //     source: ImageSource.camera, imageQuality: 25))!;
    setState(() {});
  }

  /// Get from Camera
  late String imgString;
  //
  // _getFromCamera() async {
  //   var photo = await imagePicker.pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (photo != null) {
  //     setState(() {
  //       FileImage = File(photo.path);
  //       //  imgString = Utility.base64String(FileImage!.readAsBytesSync());
  //     });
  //   }
  // }

  _getPolyline() async {
    locations = await LocationProvider().read();
    lastLocations = await LocationProvider().lastRow();
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //     googleAPiKey,
    //     PointLatLng(double.parse('${locations![0].latitude}'), double.parse('${locations![0].longitude}')),
    //     PointLatLng(31.568836, 34.564535),
    //     travelMode: TravelMode.driving,
    //     wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    // if (result.points.isNotEmpty) {
    //   result.points.forEach((PointLatLng point) {
    for (int i = 0; i < locationas!.length; i++) {
      polylineCoordinates.add(LatLng(double.parse('${locationas![i].latitude}'),
          double.parse('${locationas![i].longitude}')));
    }
    // polylineCoordinates.add(LatLng(double.parse('${locations![0].latitude}'),
    //     double.parse('${locations![0].longitude}')));
    // polylineCoordinates.add(LatLng(
    //     double.parse('${lastLocations![0].latitude}'),
    //     double.parse('${lastLocations![0].longitude}')));
    // }
    //  );
    // }
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
    print('photo_pla$photoName');
    task.details = details.text;
    task.image = photoName.toString();

    return task;
  }
}
/*
  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('position.latitude${position.latitude}');
    if (mounted) {
      setState(() {
        AppPreferences().setPlace(
            position.latitude.toString() + ',' + position.longitude.toString());
      });
    }
<<<<<<< HEAD
 */
