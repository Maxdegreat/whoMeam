part of 'feedhome_bloc.dart';

enum FeedHomeStatus { inital, loading, success, paginating, error}

class FeedhomeState extends Equatable {
  final List<Post?> posts;
  final Set<String?> likedPostIds;
  final List<Widget> postContainers;
  final Failure failure;
  final FeedHomeStatus status;

  const FeedhomeState({
    required this.posts,
    required this.likedPostIds,
    required this.postContainers,
    required this.failure,
    required this.status,
  });

  factory FeedhomeState.inital() => FeedhomeState(
      posts: const [],
      likedPostIds: const {},
      postContainers: const [],
      failure: Failure(), 
      status: FeedHomeStatus.inital);

  @override
  List<Object> get props => [posts, likedPostIds, postContainers, failure, status];

  FeedhomeState copyWith({
    List<Post?>? posts,
    Set<String?>? likedPostIds,
    List<Widget>? postContainers,
    Failure? failure,
    FeedHomeStatus? status,
  }) =>
      FeedhomeState(
          posts: posts ?? this.posts,
          likedPostIds: likedPostIds ?? this.likedPostIds,
          postContainers: postContainers ?? this.postContainers,
          failure: failure ?? this.failure,
          status: status ?? this.status);
}
