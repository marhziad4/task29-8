import 'package:flutter/material.dart';

class AppTextField1 extends StatefulWidget {
  String? hint;
  TextEditingController? controller;
  TextInputType textInputType = TextInputType.text;
  bool obscure = false;
  Widget? prefixIcon;
  int? minLines;
  Widget? suffixIcon;

  AppTextField1(
      {this.hint,
      this.controller,
      this.obscure = false,
      this.textInputType = TextInputType.text,
      this.prefixIcon,
      this.suffixIcon,
      this.minLines});

  @override
  _AppTextField1State createState() => _AppTextField1State();
}

class _AppTextField1State extends State<AppTextField1> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.textInputType,
      obscureText: widget.obscure,
      minLines: widget.minLines,
      controller: widget.controller,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        hintStyle: TextStyle(
            color: Color(0XFFF303030).withOpacity(.50),
            fontSize: 20,
            fontWeight: FontWeight.w500),
        fillColor: Colors.white30,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Color(0XFFF3F3F3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Color(0xff0f31dc), width: 0.5),
        ),
      ),
    );
  }
}
