import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whomeam/screens/create_post/create_post.dart';
import 'package:whomeam/screens/feed/bloc/feedhome_bloc.dart';

class FeedHomeScreen extends StatefulWidget {
  static const String routeName = "feedhomescreen";
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) {
          return  BlocProvider<FeedhomeBloc>(
            create: (context) => FeedhomeBloc(),
            child: const FeedHomeScreen(),
          );
        });
  }

  const FeedHomeScreen({super.key});

  @override
  State<FeedHomeScreen> createState() => _FeedHomeScreenState();
}

class _FeedHomeScreenState extends State<FeedHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedhomeBloc, FeedhomeState>(
      listener: (context, state) {
        if (state.status == FeedHomeStatus.error) {
          log("error in feedHomeStatus");
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                "NewArt",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(CreatePost.routeName);
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            body: Column(
              children: [
                if (state.status == FeedHomeStatus.loading)
                  const LinearProgressIndicator(),
                Expanded(
                  child: PageView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        return const Center(
                            child: Text("this is a demo test"));
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
