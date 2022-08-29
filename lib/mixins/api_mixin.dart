import 'dart:convert';
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:todo_emp/mixins/helpersApi.dart';
import 'package:todo_emp/preferences/user_pref.dart';

mixin ApiMixin implements HelpersApi {
  Uri getUrl(String url) {
    return Uri.parse(url);
  }

  bool isSuccessRequest(int statusCode) {
    return statusCode < 400;
  }

  void handleServerError(BuildContext context) {
    showSnackBar(
        context: context,
        message: 'Unable to perform your request now!',
        error: true);
  }

  void showMessage(BuildContext context, Response response,
      {bool error = false}) {
    showSnackBar(
        context: context,
        message: jsonDecode(response.body)['message'],
        error: error);
  }
//        message: jsonDecode(response.body)['message'],
  Map<String, String> get requestHeaders {
    String tokens = UserPreferences().token;
    List tokenSplit=tokens.split("|");

    return {
      'Content-Type': 'application/json',
       'Accept': 'application/json',
      'Authorization': 'Bearer '+UserPreferences().token,
     // HttpHeaders.authorizationHeader: ' Bearer '+UserPreferences().token,
    };
  }
}
