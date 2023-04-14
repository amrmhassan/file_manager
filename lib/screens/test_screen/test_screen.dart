// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/helpers/router_system/router.dart';
import 'package:explorer/helpers/router_system/server.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/TestScreen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      CustomRouter router = CustomRouter().get('/', [], (request, response) {
        response
          ..write('done you are here man')
          ..close();
      });
      server = await CustomServer(router, InternetAddress.anyIPv4, 2569).bind();
      logger.i('listening on ${server?.port}');
    });
    super.initState();
  }

  HttpServer? server;
  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Spacer(),
          // BeaconServersScanResultContainer(),
          ElevatedButton(
            onPressed: () async {},
            child: Text('Open'),
          ),
          ElevatedButton(
            onPressed: () async {
              await server?.close();
              logger.i('server closed');
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
