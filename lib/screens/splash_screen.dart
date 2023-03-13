import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:whomeam/screens/bottom_nav/nav_screen.dart';
import 'package:whomeam/screens/feed/feed_home_screen.dart';

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
      Navigator.pushNamed(context, FeedHomeScreen.routeName);
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
