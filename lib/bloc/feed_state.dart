part of 'feed_bloc.dart';

class FeedState extends Equatable {
  final List<Post> posts;

  const FeedState({
    required this.posts,
  });

  @override
  List<Object> get props => [posts];

  FeedState copyWith({List<Post>? posts}) {
    return FeedState(posts: posts ?? this.posts);
  }

  factory FeedState.inital() {
    return const FeedState(posts: []);
  }
}
