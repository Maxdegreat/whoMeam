import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whomeam/models/post_model.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedState.inital()) {

    
    on<FeedEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
