import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tvst/global.dart';
import 'package:tvst/models/video.dart';

class ControllerFollowingVideos extends GetxController {
  final Rx<List<Video>> _followingVideosList = Rx<List<Video>>([]);
  List<Video> get followingAllVideosList => _followingVideosList.value;

  final RxBool _isLowDataMode = false.obs;
  RxBool get isLowDataMode => _isLowDataMode;

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    getFollowingUsersVideos();
  }

  Future<void> getFollowingUsersVideos() async {
    try {
      _isLoading.value = true;

      final followingIds = await _getFollowingUserIds();

      _followingVideosList.bindStream(_getVideosStream(followingIds));
    } catch (e) {
      print("Error fetching following users' videos: $e");
    } finally {
      _isLoading.value = false;
    }
  }

  Future<List<String>> _getFollowingUserIds() async {
    final followingSnapshot = await _firestore
        .collection("users")
        .doc(currentUserID)
        .collection("following")
        .get();

    return followingSnapshot.docs.map((doc) => doc.id).toList();
  }

  Stream<List<Video>> _getVideosStream(List<String> followingIds) {
    return _firestore
        .collection("videos")
        .orderBy("publishedDateTime", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .where((doc) => followingIds.contains(doc['userID']))
          .map((doc) => Video.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  Future<void> likeOrUnlikeVideo(String videoID) async {
    try {
      final currentUserID = _auth.currentUser?.uid;
      if (currentUserID == null) return;

      final videoRef = _firestore.collection("videos").doc(videoID);
      final videoDoc = await videoRef.get();

      if (!videoDoc.exists) return;

      final likesList = List<String>.from(videoDoc['likesList'] ?? []);

      if (likesList.contains(currentUserID)) {
        await videoRef.update({
          "likesList": FieldValue.arrayRemove([currentUserID])
        });
      } else {
        await videoRef.update({
          "likesList": FieldValue.arrayUnion([currentUserID])
        });
      }
    } catch (e) {
      print("Error liking/unliking video: $e");
    }
  }

  void toggleLowDataMode() {
    _isLowDataMode.value = !_isLowDataMode.value;
    // Implement logic to adjust video quality based on low data mode
  }
}
