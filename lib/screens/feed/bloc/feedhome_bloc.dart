import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:whomeam/models/failure_model.dart';
import 'package:whomeam/models/post_model.dart';

part 'feedhome_event.dart';
part 'feedhome_state.dart';

class FeedhomeBloc extends Bloc<FeedhomeEvent, FeedhomeState> {

  FeedhomeBloc()  : 
        super(FeedhomeState.inital());

  @override
  Stream<FeedhomeState> mapEventToState(FeedhomeEvent event) async* {
    if (event is FeedhomeFetchPosts) {
      yield* _mapFeedhomeFetchPostsToState();
    } else if (event is FeedhomePaginatePosts) {
      yield* _mapFeedhomepaginatePostsToState();
    }
  }

  Stream<FeedhomeState> _mapFeedhomeFetchPostsToState() async* {
    try {
      yield state.copyWith(status: FeedHomeStatus.loading);
      List<Post?> feed = [];
      yield state.copyWith(posts: feed, status: FeedHomeStatus.inital);
    } catch (e) {
      log("error in feedhomeBloc -> _mapFedhomeFetchPostToState() -> $e");
    }
  }

  Stream<FeedhomeState> _mapFeedhomepaginatePostsToState() async* {
    try {} catch (e) {
      log("error in feedhomeBloc -> _mapFedhomePaginatePostToState() -> $e");
    }
  }
}
