
import 'package:equatable/equatable.dart';
import 'package:whomeam/config/paths.dart';
import 'package:whomeam/models/user_model.dart';

class Post extends Equatable {
  final String? id;
  final Userm author;
  final List<String> dalleArtUrls;
  final int likes;
  final int commentCount;
  final Map<String, dynamic> metadata;

  const Post(
      {this.id,
      required this.author,
      required this.dalleArtUrls,
      required this.likes,
      required this.commentCount,
      required this.metadata});

  @override
  List<Object?> get props => [id, author, dalleArtUrls, likes, commentCount];

  static Post empty() => Post(
      author: Userm.empty,
      dalleArtUrls: const [],
      likes: 0,
      commentCount: 0,
      metadata: const {});

  Post copyWith({
    String? id,
    Userm? author,
    List<String>? dalleArtUrls,
    int? likes,
    int? commentCount,
    Map<String, dynamic>? metadata,
  }) {
    return Post(
        author: author ?? this.author,
        dalleArtUrls: dalleArtUrls ?? this.dalleArtUrls,
        likes: likes ?? this.likes,
        commentCount: commentCount ?? this.commentCount,
        metadata: metadata ?? this.metadata);
  }



}
