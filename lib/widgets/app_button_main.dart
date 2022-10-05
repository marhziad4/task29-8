import 'package:flutter/material.dart';

class AppButtonMain extends StatelessWidget {
  late void Function() onPressed;
  late String? title;

  AppButtonMain({required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xff0f31dc),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title ?? "",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
            fontFamily: 'NotoNaskhArabic',
          ),
        ),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            primary: Colors.transparent),
      ),
    );
  }
}
