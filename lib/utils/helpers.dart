import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin Helpers {
  void showSnackBar(
      {required BuildContext context,
      required String content,
      bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  void showLogoutDialog(
      {required BuildContext context,
      required String title,
      required String subTittle,
      required}) {
    showDialog(
        barrierColor: Colors.red.withOpacity(0.4),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(subTittle),
            actions: [
              TextButton(onPressed: () {}, child: Text('YES')),
              TextButton(onPressed: () {}, child: Text('NO')),
            ],
// actionsPadding: EdgeInsets.symmetric(horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
  }
}
