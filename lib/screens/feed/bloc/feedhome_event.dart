part of 'feedhome_bloc.dart';

abstract class FeedhomeEvent extends Equatable {
  const FeedhomeEvent();

  @override
  List<Object> get props => [];
}

class FeedhomeFetchPosts extends FeedhomeEvent {}

class FeedhomePaginatePosts extends FeedhomeEvent {}
