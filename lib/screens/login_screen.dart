import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:whomeam/repository/auth_repo.dart';

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
                    try {
                      context.read<AuthRepository>().signInWithGoogle();
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                ),
                ElevatedButton(
                  child: Text(
                    "Continue with Apple",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: () async {
                    try {
                      context.read<AuthRepository>().signInWithApple(context);
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
