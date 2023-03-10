import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whomeam/config/custom_router.dart';
import 'package:whomeam/repository/open_ai_repo.dart';
import 'package:whomeam/screens/bottom_nav/cubit/bottomnav_cubit.dart';
import 'package:whomeam/screens/login_screen.dart';
import 'package:whomeam/theme/theme_info.dart';

// 15.93 + 26.55
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // lets keep the splash till app is one initializing
  // MobileAds.instance.initialize();
  EquatableConfig.stringify = kDebugMode;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OpenaiRepo>(create: (_) => OpenaiRepo()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BottomnavCubit>(
            create: (context) => BottomnavCubit()
          )
        ],
        child: MaterialApp(
          title: 'WhoMeam',
          themeMode: ThemeMode.dark,
          theme: ThemeInfo().themeClubHouseLight(),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: LoginScreen.routeName,
        ),
      ),
    );
  }
}
