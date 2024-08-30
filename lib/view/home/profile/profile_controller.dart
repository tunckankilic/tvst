import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tvst/global.dart';
import 'package:tvst/view/home/home_screen.dart';
import 'package:path/path.dart' as path;

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<Map<String, dynamic>> _userMap = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get userMap => _userMap.value;
  final Rx<String> _userID = "".obs;
  List<String> followingKeysList = [];
  List followingUsersDataList = [];

  String? facebook = "";
  String? youtube = "";
  String? instagram = "";
  String? twitter = "";
  String? userImageUrl = "";

  TextEditingController facebookTextEditingController = TextEditingController();
  TextEditingController youtubeTextEditingController = TextEditingController();
  TextEditingController instagramTextEditingController =
      TextEditingController();
  TextEditingController twitterTextEditingController = TextEditingController();

  updateCurrentUserID(String visitUserID) {
    _userID.value = visitUserID;

    retrieveUserInformation();
  }

  Future<void> followUser(String userIDToFollow) async {
    // Update the follower's collection in the target user document
    await _firestore
        .collection("users")
        .doc(userIDToFollow)
        .collection("followers")
        .doc(currentUserID)
        .set({
      "userID": currentUserID,
      "followedAt": Timestamp.now(),
    });

    // Update the following collection in the current user document
    await _firestore
        .collection("users")
        .doc(currentUserID)
        .collection("following")
        .doc(userIDToFollow)
        .set({
      "userID": userIDToFollow,
      "followedAt": Timestamp.now(),
    });

    // Update follower and following count
    await _updateFollowerAndFollowingCount(userIDToFollow, increment: true);
  }

  Future<void> unFollowUser(String userIDToUnfollow) async {
    // Remove from the follower's collection in the target user document
    await _firestore
        .collection("users")
        .doc(userIDToUnfollow)
        .collection("followers")
        .doc(currentUserID)
        .delete();

    // Remove from the following collection in the current user document
    await _firestore
        .collection("users")
        .doc(currentUserID)
        .collection("following")
        .doc(userIDToUnfollow)
        .delete();

    // Update follower and following count
    await _updateFollowerAndFollowingCount(userIDToUnfollow, increment: false);
  }

  Future<void> _updateFollowerAndFollowingCount(String userIDToFollowOrUnfollow,
      {required bool increment}) async {
    final incrementValue = increment ? 1 : -1;

    // Update follower count in target user document
    final userDocRef =
        _firestore.collection("users").doc(userIDToFollowOrUnfollow);
    await userDocRef.update({
      "totalFollowers": FieldValue.increment(incrementValue),
    });

    // Update following count in current user document
    final currentUserDocRef = _firestore.collection("users").doc(currentUserID);
    await currentUserDocRef.update({
      "totalFollowing": FieldValue.increment(incrementValue),
    });

    // Refresh the user data to reflect the new follower/following counts
    await getCurrentUserData();
  }

  // ProfileController sınıfına eklenecek yeni fonksiyon
  Future<void> updateProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        // Resmi Firebase Storage'a yükle
        String fileName = path.basename(imageFile.path);
        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/$currentUserID/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Firestore'daki kullanıcı belgesini güncelle
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserID)
            .update({"image": downloadUrl});

        // Yerel state'i güncelle
        userImageUrl = downloadUrl;
        _userMap.value.update("userImage", (_) => downloadUrl);

        Get.snackbar("Success", "Profile image updated successfully");
      } catch (error) {
        Get.snackbar("Error", "Failed to update profile image: $error");
      }
    } else {
      Get.snackbar("Cancelled", "Image selection cancelled");
    }
    update();
  }

  retrieveUserInformation() async {
    //get user info
    DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .get();

    final userInfo = userDocumentSnapshot.data() as dynamic;

    String userName = userInfo["name"];
    String userEmail = userInfo["email"];
    String userImage = userInfo["image"];
    String userUID = userInfo["uid"];
    String userYoutube = userInfo["youtube"] ?? "";
    String userInstagram = userInfo["instagram"] ?? "";
    String userTwitter = userInfo["twitter"] ?? "";
    String userFacebook = userInfo["facebook"] ?? "";

    int totalLikes = 0;
    int totalFollowers = 0;
    int totalFollowings = 0;
    bool isFollowing = false;
    List<String> thumbnailsList = [];

    //get user's videos info
    var currentUserVideos = await FirebaseFirestore.instance
        .collection("videos")
        .orderBy("publishedDateTime", descending: true)
        .where("userID", isEqualTo: _userID.value)
        .get();

    for (int i = 0; i < currentUserVideos.docs.length; i++) {
      thumbnailsList
          .add((currentUserVideos.docs[i].data() as dynamic)["thumbnailUrl"]);
    }

    //get total number of likes
    for (var eachVideo in currentUserVideos.docs) {
      totalLikes = totalLikes + (eachVideo.data()["likesList"] as List).length;
    }

    //get the total number of followers
    var followersNumDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .collection("followers")
        .get();
    totalFollowers = followersNumDocument.docs.length;

    //get the total number of followings
    var followingsNumDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .collection("following")
        .get();
    totalFollowings = followingsNumDocument.docs.length;

    //get the isFollowing true or false value
    //check if online currentUserID exists inside the followers List of visited profilePerson
    FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .collection("followers")
        .doc(currentUserID)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _userMap.value = {
      "userName": userName,
      "userEmail": userEmail,
      "userImage": userImage,
      "userUID": userUID,
      "userYoutube": userYoutube,
      "userInstagram": userInstagram,
      "userTwitter": userTwitter,
      "userFacebook": userFacebook,
      "totalLikes": totalLikes.toString(),
      "totalFollowers": totalFollowers.toString(),
      "totalFollowings": totalFollowings.toString(),
      "isFollowing": isFollowing,
      "thumbnailsList": thumbnailsList,
    };

    update();
  }

  followUnFollowUser() async {
    //1. currentUser = already logged-in online user
    //2. other user = [visitor's profile]

    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .collection("followers")
        .doc(currentUserID)
        .get();

    //currentUser is Already following other user [visitor's profile]
    if (document.exists) {
      //remove follower
      //remove following

      //1. remove currentUser as a follower from visitorPerson's followersList
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userID.value)
          .collection("followers")
          .doc(currentUserID)
          .delete();

      //2. remove that visitorProfile's person from the current user's followingList
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("following")
          .doc(_userID.value)
          .delete();

      //decrement - update totalFollowers number
      _userMap.value.update(
          "totalFollowers", (value) => (int.parse(value) - 1).toString());
    }
    //if currentUser is NOT Already following the other user [visitor's profile]
    else {
      //add new follower
      //add new following

      //1. add currentUser as a new follower to visitor's followersList
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userID.value)
          .collection("followers")
          .doc(currentUserID)
          .set({});

      //2. add that visitProfile person as a new following to the current user's followingList
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("following")
          .doc(_userID.value)
          .set({});

      //increment - update totalFollowers number
      _userMap.value.update(
          "totalFollowers", (value) => (int.parse(value) + 1).toString());
    }

    _userMap.value.update("isFollowing", (value) => !value);

    update();
  }

  updateUserSocialAccountLinks(
      String facebook, String youtube, String twitter, String instagram) async {
    try {
      final Map<String, dynamic> userSocialLinksMap = {
        "facebook": facebook,
        "youtube": youtube,
        "twitter": twitter,
        "instagram": instagram,
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .update(userSocialLinksMap);

      Get.snackbar(
          "Social Links", "your social links are updated successfully.");

      Get.to(const HomeScreen());
    } catch (errorMsg) {
      Get.snackbar("Error Updating Account", "Please try again.");
    }
  }

  getFollowingListKeys(String visitedProfileUserID) async {
    var followingDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(visitedProfileUserID)
        .collection("following")
        .get();

    for (int i = 0; i < followingDocument.docs.length; i++) {
      followingKeysList.add(followingDocument.docs[i].id);
    }

    getFollowingKeysDataFromUsersCollection(followingKeysList);
  }

  getFollowingKeysDataFromUsersCollection(
      List<String> listOfFollowingKeys) async {
    var allUsersDocument =
        await FirebaseFirestore.instance.collection("users").get();

    for (int i = 0; i < allUsersDocument.docs.length; i++) {
      for (int j = 0; j < listOfFollowingKeys.length; j++) {
        if (((allUsersDocument.docs[i].data() as dynamic)["uid"]) ==
            listOfFollowingKeys[j]) {
          followingUsersDataList.add((allUsersDocument.docs[i].data()));
        }
      }
    }

    followingUsersDataList;
    update();
  }

  List<String> followersKeysList = [];
  List followerUsersDataList = [];

  getFollowersListKeys(String visitedProfileUserID) async {
    var followingDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(visitedProfileUserID)
        .collection("followers")
        .get();

    for (int i = 0; i < followingDocument.docs.length; i++) {
      followersKeysList.add(followingDocument.docs[i].id);
    }

    getFollowersKeysDataFromUsersCollection(followersKeysList);
  }

  getFollowersKeysDataFromUsersCollection(
      List<String> listOfFollowingKeys) async {
    var allUsersDocument =
        await FirebaseFirestore.instance.collection("users").get();

    for (int i = 0; i < allUsersDocument.docs.length; i++) {
      for (int j = 0; j < listOfFollowingKeys.length; j++) {
        if (((allUsersDocument.docs[i].data() as dynamic)["uid"]) ==
            listOfFollowingKeys[j]) {
          followerUsersDataList.add((allUsersDocument.docs[i].data()));
        }
      }
    }

    followerUsersDataList;
    update();
  }

  getCurrentUserData() async {
    try {
      DocumentSnapshot snapshotUser = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .get();

      if (!snapshotUser.exists) {
        Get.snackbar("Error", "User data not found");
        return;
      }

      facebook = snapshotUser["facebook"];
      youtube = snapshotUser["youtube"];
      instagram = snapshotUser["instagram"];
      twitter = snapshotUser["twitter"];
      userImageUrl = snapshotUser["image"];
      facebookTextEditingController.text = facebook ?? "";
      youtubeTextEditingController.text = youtube ?? "";
      instagramTextEditingController.text = instagram ?? "";
      twitterTextEditingController.text = twitter ?? "";
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to load user data: $e");
      print("Error in getCurrentUserData: $e");
    }
  }

  @override
  void onInit() {
    getCurrentUserData();
    super.onInit();
  }
}
