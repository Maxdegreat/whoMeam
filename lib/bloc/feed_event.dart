part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class LoadPosts extends FeedEvent {
  const LoadPosts();
}

class UpdatePost extends FeedEvent {
  final Post p;

  const UpdatePost(this.p);
}
