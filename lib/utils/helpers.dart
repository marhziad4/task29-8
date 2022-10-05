import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_emp/controller/UserApiController.dart';

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
        barrierColor: Colors.black.withOpacity(0.4),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(subTittle),
            actions: [
              TextButton(
                  onPressed: () async {
                    bool status =
                        await UserApiController().logout(context: context);
                    if (status) {
                      Navigator.pushReplacementNamed(context, '/Login_screen');
                    }
                  },
                  child: Text('نعم')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('لا')),
            ],
// actionsPadding: EdgeInsets.symmetric(horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
  }
}
