import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo_emp/api/api_settings.dart';
import 'package:todo_emp/model/login.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:http/http.dart' as http;

class UserApiController with Helpers {
  Future<bool> login(
      {required BuildContext context,
      required String username,
      required String password}) async {
    var url = Uri.parse(ApiSettings.LOGIN);
    var response = await http
        .post(url, body: {'username': username, 'password': password});
    var jsonResponse = jsonDecode(response.body);
    // print(jsonResponse);
    //   print('${jsonResponse['access_token']}');

    if (response.statusCode == 200) {
      loginUser users = loginUser.fromJson(jsonDecode(response.body));
      var user = await UserPreferences().save(users);
      var token =
          await UserPreferences().setToken(jsonResponse['access_token']);
      // print('${token}');
      // List<loginapi> userlist=[];
      // userlist.add(users);
      //
      // for(int i=0;i>userlist.length;i++){
      //   print(i);
      // }

      print('token:${UserPreferences().token}');
      print('user:${UserPreferences().isLoggedIn}');

      return true;
    } else if (response.statusCode == 401) {
      showSnackBar(
          context: context, content: 'خطا في تسجيل الدخول', error: true);
    } else {
      showSnackBar(
          context: context, content: ' يرجى المحاولة فيما بعد', error: true);
    }
    return false;
  }

  Future<bool> logout({required BuildContext context}) async {
    print('api');
    var url = Uri.parse(ApiSettings.LOGOUT);
    var response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: UserPreferences().token
      },
    );
    print('token:${UserPreferences().token}');
    if (response.statusCode != 400) {
      await UserPreferences().logout();

      showSnackBar(
        context: context,
        content: '   تم تسجيل الخروج بنجاح',
      );

      return true;
    } else if (response.statusCode != 500) {
      showSnackBar(
          context: context, content: ' يرجى المحاولة فيما بعد', error: true);
    } else {
      showSnackBar(context: context, content: 'SERVER ERROR', error: true);
    }
    return false;
  }
}
