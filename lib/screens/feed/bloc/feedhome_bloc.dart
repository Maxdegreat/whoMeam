import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:whomeam/blocs/bloc/auth_bloc.dart';
import 'package:whomeam/models/failure_model.dart';
import 'package:whomeam/models/post_model.dart';
import 'package:whomeam/repository/post_repo.dart';

part 'feedhome_event.dart';
part 'feedhome_state.dart';

class FeedhomeBloc extends Bloc<FeedhomeEvent, FeedhomeState> {
  final AuthBloc _authBloc;
  final PostRepository _postRepository;
  FeedhomeBloc({
    required AuthBloc authBloc,
    required PostRepository postRepository,
  })  : _authBloc = authBloc,
        _postRepository = postRepository,
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
      String uid = _authBloc.state.user!.uid;
      List<Post?> feed = await _postRepository.fetchPost(userId: uid);
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
