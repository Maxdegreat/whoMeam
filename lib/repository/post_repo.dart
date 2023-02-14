import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whomeam/config/paths.dart';
import 'package:whomeam/models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firebaseFirestore;
  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  void createPost({required Post post}) {
    _firebaseFirestore.collection(Paths.posts).add(post.toDoc());
  }

  Future<List<Post?>> fetchPost({required String userId}) async {
    List<Post?> posts = [];
    QuerySnapshot querysnaps =
        await _firebaseFirestore.collection(Paths.posts).limit(7).get();

    if (querysnaps.docs.isEmpty) {
      return const [];
    }

    for (var i in querysnaps.docs) {
      Post? post = await Post.fromDoc(i);
      posts.add(post);
    }

    return posts;
  }
}
