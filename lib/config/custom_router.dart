import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whomeam/screens/bottom_nav/nav_screen.dart';
import 'package:whomeam/screens/create_post/create_post.dart';
import 'package:whomeam/screens/login_screen.dart';
import 'package:whomeam/screens/splash_screen.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    log('Route: ${settings.name}');
    switch (settings.name) {
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case CreatePost.routeName:
        return CreatePost.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    log('Nested Route: ${settings.name}');
    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(
      //     settings: const RouteSettings(name: '/'),
      //     builder: (_) => Scaffold(),
      //   );

      case CreatePost.routeName:
        return CreatePost.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
