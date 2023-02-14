import 'package:equatable/equatable.dart';

class Musenet extends Equatable {
  final String? id;
  final String url;
  final String authorId;

  const Musenet({this.id, required this.url, required this.authorId});


  @override
  List<Object?> get props => [id, url, authorId];

}
