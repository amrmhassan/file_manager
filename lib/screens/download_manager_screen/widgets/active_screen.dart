// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ActiveScreen extends StatelessWidget {
  const ActiveScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.green,
      child: Text('Active Screen'),
    );
  }
}
