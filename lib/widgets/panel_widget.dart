import 'package:flutter/material.dart';
import 'package:todo_emp/widgets/app_text_field.dart';

class panelWidget extends StatefulWidget {
  const panelWidget({Key? key}) : super(key: key);

  @override
  State<panelWidget> createState() => _panelWidgetState();
}

late TextEditingController details;

@override
void initState() {
  // TODO: implement initState

  details = TextEditingController();

  // _cameraPosition = CameraPosition(target: LatLng(31.568836, 34.564535),
  //   zoom: 5,
  // );
}

@override
void dispose() {
  details.dispose();
}

class _panelWidgetState extends State<panelWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 36,
        ),
        Text(
          'عنوان المكان',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'اضف ملاحظة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        AppTextField1(hint: "ملاحظات", controller: details),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                Container(
                  height: 150,
                  width: 100,
                  child: Card(
                    child: Text('hh'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
                ),
                Container(
                  height: 150,
                  width: 100,
                  child: Card(
                    child: Text('hh'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
