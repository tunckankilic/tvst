import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tvst/models/comment.dart';

class CommentsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxString _currentVideoID = ''.obs;
  final RxList<Comment> _commentsList = <Comment>[].obs;
  final RxBool _isLoading = false.obs;

  String get currentVideoID => _currentVideoID.value;
  List<Comment> get listOfComments => _commentsList;
  RxBool get isLoading => _isLoading;

  void updateCurrentVideoID(String videoID) {
    _currentVideoID.value = videoID;
    retrieveComments();
  }

  Future<void> saveNewCommentToDatabase(String commentTextData) async {
    try {
      _isLoading.value = true;
      final String commentID = DateTime.now().millisecondsSinceEpoch.toString();
      final String userID = _auth.currentUser?.uid ?? '';

      final userDoc = await _firestore.collection("users").doc(userID).get();
      final userData = userDoc.data() as Map<String, dynamic>? ?? {};

      final Comment commentModel = Comment(
        userName: userData['name'] ?? '',
        userID: userID,
        userProfileImage: userData['image'] ?? '',
        commentText: commentTextData,
        commentID: commentID,
        commentLikesList: [],
        publishedDateTime: DateTime.now(),
      );

      final batch = _firestore.batch();

      // Save new comment
      batch.set(
        _firestore
            .collection("videos")
            .doc(currentVideoID)
            .collection("comments")
            .doc(commentID),
        commentModel.toJson(),
      );

      // Update comment counter
      final videoDoc = _firestore.collection("videos").doc(currentVideoID);
      batch.update(videoDoc, {
        "totalComments": FieldValue.increment(1),
      });

      await batch.commit();

      Get.snackbar("Success", "Comment posted successfully");
    } catch (errorMsg) {
      Get.snackbar("Error", "Failed to post comment: $errorMsg");
    } finally {
      _isLoading.value = false;
    }
  }

  void retrieveComments() {
    _isLoading.value = true;
    _commentsList.bindStream(
      _firestore
          .collection("videos")
          .doc(currentVideoID)
          .collection("comments")
          .orderBy("publishedDateTime", descending: true)
          .snapshots()
          .map((QuerySnapshot commentsSnapshot) {
        return commentsSnapshot.docs
            .map((doc) => Comment.fromDocumentSnapshot(doc))
            .toList();
      }),
    );
    _isLoading.value = false;
  }

  Future<void> likeUnlikeComment(String commentID) async {
    try {
      final String userID = _auth.currentUser?.uid ?? '';
      if (userID.isEmpty) return;

      final commentRef = _firestore
          .collection("videos")
          .doc(currentVideoID)
          .collection("comments")
          .doc(commentID);

      final commentDoc = await commentRef.get();
      final likesList = List<String>.from(commentDoc['commentLikesList'] ?? []);

      if (likesList.contains(userID)) {
        await commentRef.update({
          "commentLikesList": FieldValue.arrayRemove([userID]),
        });
      } else {
        await commentRef.update({
          "commentLikesList": FieldValue.arrayUnion([userID]),
        });
      }
    } catch (errorMsg) {
      Get.snackbar("Error", "Failed to like/unlike comment: $errorMsg");
    }
  }
}
