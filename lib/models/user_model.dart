import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Userm extends Equatable {
  final String id;
  final String username;
  final List<String> usernameSearchCase;
  final String email;
  final List<String> token;
  final String bio;
  final String profileImageUrl;
  final String bannerImageUrl;
  final int following;
  final int meamers;
  final Map<String, dynamic> data;

  Userm({
    required this.id,
    required this.username,
    required this.usernameSearchCase,
    required this.email,
    required this.token,
    required this.bio,
    required this.profileImageUrl,
    required this.bannerImageUrl,
    required this.following,
    required this.meamers,
    required this.data,
  });

  static Userm empty = Userm(
    id: '1111111',
    username: 'not found',
    usernameSearchCase: const [],
    email: '',
    token: const [],
    following: 0,
    meamers: 0,
    profileImageUrl: '',
    bannerImageUrl: '',
    bio: '',
    data: const {},
  );

  static Userm mock = Userm(
    email: '',
    token: const [],
    following: 0,
    meamers: 0,
    usernameSearchCase: const [],
    bio: '',
    id: "mock1111111",
    profileImageUrl: "",
    bannerImageUrl: "",
    username: "mock",
    data: const {},
  );

  @override
  List<Object?> get props => [
        id,
        username,
        usernameSearchCase,
        email,
        bio,
        token,
        profileImageUrl,
        bannerImageUrl,
        following,
        meamers,
        data,
      ];

  Userm copyWith({
    String? id,
    String? username,
    List<String>? usernameSearchCase,
    String? email,
    String? bio,
    List<String>? token,
    String? profileImageUrl,
    String? bannerImageUrl,
    int? meamers,
    int? following,
    Map<String, dynamic>? data,
  }) {
    return Userm(
      id: id ?? this.id,
      username: username ?? this.username,
      usernameSearchCase: usernameSearchCase ?? this.usernameSearchCase,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      token: token ?? this.token,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      following: following ?? this.following,
      meamers: meamers ?? this.meamers,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      'username': username,
      'usernameSearchCase': usernameSearchCase,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'bannerImageUrl': bannerImageUrl,
      'following': following,
      'meamers': meamers,
      'data': data,
    };
  }

  factory Userm.getId(DocumentSnapshot doc) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _data = doc.data() as Map<String, dynamic>;
    return Userm(
      id: doc.id,
      username: '',
      usernameSearchCase: const [],
      email: '',
      token: const [],
      bio: 'bio',
      profileImageUrl: '',
      bannerImageUrl: '',
      following: 0,
      meamers: 0,
      data: const {}
    );
  }

  factory Userm.fromDoc(DocumentSnapshot doc) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _data = doc.data() as Map<String, dynamic>;
    return Userm(
        id: doc.id,
        username: _data['username'] ?? '',
        usernameSearchCase:
            List<String>.from(_data['usernameSearchCase'] ?? []),
        email: _data['email'] ?? '',
        profileImageUrl: _data['profileImageUrl'] ?? '',
        bannerImageUrl: _data['bannerImageUrl'] ?? '',
        bio: _data['bio'] ?? '',
        following: (_data['following'] ?? 0).toInt(),
        meamers: (_data['meamers'] ?? 0).toInt(),
        token: List<String>.from(_data['token']),
        data: Map<String, dynamic>.from(_data['data']));
  }
}
