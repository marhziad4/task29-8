import 'package:flutter/material.dart';

class DetailsApiTasksScreen extends StatelessWidget {
  const DetailsApiTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff0f31dc),
        title: Text(
          'تفاصيل',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
    );
  }
}
