

import 'package:flutter/material.dart';

class Loading2 extends StatelessWidget {
  const Loading2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
