import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whomeam/screens/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});
  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) =>
            const LoginScreen()); //buildcontext, animaitons ;
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "NewArt",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 50),
                ),
                const SizedBox(height: 30),
                const Icon(Icons.sentiment_very_satisfied, size: 60),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: Text(
                    "Continue with Google",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushNamed(SplashScreen.routeName);
                  },
                ),
                ElevatedButton(
                  child: Text(
                    "Continue with Apple",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushNamed(SplashScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
