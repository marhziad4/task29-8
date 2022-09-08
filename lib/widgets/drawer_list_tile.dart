import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  IconData iconData;
  String title;
  void Function() onTab;
  String counter;

  DrawerListTile(
      {required this.iconData,
      required this.title,
      required this.onTab,
        required this.counter});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTab,
      leading: Icon(
        iconData,
        color: Color(0xff1565C0),
      ),
      trailing: Text(
        counter,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black,
          fontFamily: 'NotoNaskhArabic',
        ),
      ),
    );
  }
}
