import 'package:flutter/material.dart';
class LoadingDailog extends StatelessWidget {
  const LoadingDailog({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
   return Dialog(
      // The background color
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            // The loading indicator
            CircularProgressIndicator(),
            SizedBox(
              height: 15,
            ),
            // Some text
            Text('تحميل...')
          ],
        ),
      ),
    );
  }
}
