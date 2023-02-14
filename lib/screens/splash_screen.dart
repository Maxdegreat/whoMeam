import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whomeam/blocs/bloc/auth_bloc.dart';
import 'package:whomeam/screens/bottom_nav/nav_screen.dart';
import 'package:whomeam/screens/login_screen.dart';

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
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prevState, state) =>
          prevState.status !=
          state
              .status, // Prevent listener from triggering if status did not change
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenicated) {
          log("unauth");
          //go to login Screen
          Navigator.pushNamed(context, LoginScreen.routeName);
        } else if (state.status == AuthStatus.authenticated) {
          log("auth");
          Navigator.pushNamed(context, NavScreen.routeName);
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.red,
          )),
        );
      },
    );
  }
}
