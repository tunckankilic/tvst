import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tvst/global.dart';
import 'package:tvst/view/home/profile/followers_screen.dart';
import 'package:tvst/view/home/profile/following_screen.dart';
import 'package:tvst/view/home/profile/profile_controller.dart';
import 'package:tvst/view/inner_screens/video/video_player_profile.dart';
import 'package:tvst/view/home/profile/account_settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String? visitUserID;

  const ProfileScreen({Key? key, this.visitUserID}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controllerProfile = Get.put(ProfileController());
  bool isFollowingUser = false;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    await controllerProfile
        .updateCurrentUserID(widget.visitUserID ?? currentUserID);
    await _getIsFollowingValue();
  }

  Future<void> _getIsFollowingValue() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.visitUserID)
        .collection("followers")
        .doc(currentUserID)
        .get();
    setState(() {
      isFollowingUser = doc.exists;
    });
  }

  Future<void> _launchUserSocialProfile(String socialLink) async {
    final url = Uri.parse("https://$socialLink");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar("Error", "Could not launch $socialLink");
    }
  }

  void _handleClickEvent(String choice) {
    switch (choice) {
      case "Settings":
        Get.to(() => const AccountSettingsScreen());
        break;
      case "Logout":
        FirebaseAuth.instance.signOut();
        Get.snackbar("Logged Out", "You are logged out from the app.");
        break;
    }
  }

  Future<void> _readClickedThumbnailInfo(String clickedThumbnailUrl) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("videos")
        .where("thumbnailUrl", isEqualTo: clickedThumbnailUrl)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final videoData = querySnapshot.docs.first.data();
      Get.to(() => VideoPlayerProfile(clickedVideoID: videoData["videoID"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controllerProfile) {
        if (controllerProfile.userMap.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _initializeProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 16),
                    _buildSocialLinks(),
                    const SizedBox(height: 16),
                    _buildActionButton(),
                    _buildVideoGrid(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        controllerProfile.userMap["userName"] ?? "",
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        if (widget.visitUserID == currentUserID)
          PopupMenuButton<String>(
            onSelected: _handleClickEvent,
            itemBuilder: (BuildContext context) {
              return {"Settings", "Logout"}.map((String choice) {
                return PopupMenuItem(value: choice, child: Text(choice));
              }).toList();
            },
          ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 50,
      backgroundImage:
          NetworkImage(controllerProfile.userMap["userImage"] ?? ""),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem(
            "Following", controllerProfile.userMap["totalFollowings"], () {
          Get.to(() =>
              FollowingScreen(visitedProfileUserID: widget.visitUserID ?? ""));
        }),
        _buildVerticalDivider(),
        _buildStatItem("Followers", controllerProfile.userMap["totalFollowers"],
            () {
          Get.to(() =>
              FollowersScreen(visitedProfileUserID: widget.visitUserID ?? ""));
        }),
        _buildVerticalDivider(),
        _buildStatItem("Likes", controllerProfile.userMap["totalLikes"], () {}),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      color: Colors.black54,
      width: 1,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _buildSocialLinks() {
    final socialLinks = [
      {"key": "userFacebook", "asset": "images/facebook.png"},
      {"key": "userInstagram", "asset": "images/instagram.png"},
      {"key": "userTwitter", "asset": "images/twitter.png"},
      {"key": "userYoutube", "asset": "images/youtube.png"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socialLinks.map((link) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: () {
              final socialLink = controllerProfile.userMap[link["key"]];
              if (socialLink == null || socialLink.isEmpty) {
                Get.snackbar("Profile Not Connected",
                    "This user has not connected their ${link["key"]!.substring(4)} profile yet.");
              } else {
                _launchUserSocialProfile(socialLink);
              }
            },
            child: Image.asset(link["asset"]!, width: 50),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton() {
    final isOwnProfile = widget.visitUserID == currentUserID;
    final buttonText =
        isOwnProfile ? "Sign Out" : (isFollowingUser ? "Unfollow" : "Follow");
    final buttonColor =
        isOwnProfile || isFollowingUser ? Colors.red : Colors.green;

    return ElevatedButton(
      onPressed: () {
        if (isOwnProfile) {
          FirebaseAuth.instance.signOut();
          Get.snackbar('Logged Out', 'You are logged out from the app.');
        } else {
          setState(() {
            isFollowingUser = !isFollowingUser;
          });
          controllerProfile.followUnFollowUser();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 90),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: buttonColor),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildVideoGrid() {
    final thumbnails =
        controllerProfile.userMap["thumbnailsList"] as List<dynamic>? ?? [];
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: thumbnails.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: .7,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final thumbnailUrl = thumbnails[index];
        return GestureDetector(
          onTap: () => _readClickedThumbnailInfo(thumbnailUrl),
          child: Image.network(thumbnailUrl, fit: BoxFit.cover),
        );
      },
    );
  }
}
