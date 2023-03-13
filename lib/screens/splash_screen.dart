import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:whomeam/screens/create_post/create_post.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SplashScreen());
  }

//implement auth bloc
// wrap scaffold in a bloc listener
  @override
  Widget build(BuildContext context) {

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Navigator.pushNamed(context, CreatePost.routeName);
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.red,
      )),
    );
  }
}
