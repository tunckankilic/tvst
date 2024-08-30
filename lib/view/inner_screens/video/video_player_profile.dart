// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tvst/view/inner_screens/comments/comments_screen.dart';
import 'package:tvst/view/inner_screens/video/video_controller_profile.dart';
import 'package:tvst/view/widgets/circular_image_animation.dart';
import 'package:tvst/view/widgets/custom_video_player.dart';

class VideoPlayerProfile extends GetView<VideoControllerProfile> {
  String clickedVideoID;

  VideoPlayerProfile({
    super.key,
    required this.clickedVideoID,
  });

  final VideoControllerProfile controllerVideoProfile =
      Get.put(VideoControllerProfile());

  @override
  Widget build(BuildContext context) {
    controllerVideoProfile.setVideoID(clickedVideoID.toString());
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: controllerVideoProfile.clickedVideoFile.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final clickedVideoInfo =
                controllerVideoProfile.clickedVideoFile[index];

            return Stack(
              children: [
                Semantics(
                  label: 'Video player',
                  child: CustomVideoPlayer(
                    videoFileUrl: clickedVideoInfo.videoUrl.toString(),
                    isLowDataMode: controller.isLowDataMode,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 110),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildLeftPanel(clickedVideoInfo),
                          _buildRightPanel(clickedVideoInfo),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.isLowDataMode.value = !controller.isLowDataMode.value;
        },
        child: Icon(controller.isLowDataMode.value
            ? Icons.network_cell
            : Icons.network_wifi),
      ),
    );
  }

  Widget _buildLeftPanel(dynamic clickedVideoInfo) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "@${clickedVideoInfo.userName}",
              style: GoogleFonts.abel(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              clickedVideoInfo.descriptionTags.toString(),
              style: GoogleFonts.abel(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Image.asset(
                  "images/music_note.png",
                  width: 20,
                  color: Colors.white,
                ),
                Expanded(
                  child: Text(
                    "  ${clickedVideoInfo.artistSongName}",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alexBrush(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel(dynamic clickedVideoInfo) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildProfileImage(clickedVideoInfo),
          _buildInteractionButton(
            icon: Icons.favorite_rounded,
            count: clickedVideoInfo.likesList!.length,
            onPressed: () => controllerVideoProfile
                .likeOrUnlikeVideo(clickedVideoInfo.videoID.toString()),
            color: clickedVideoInfo.likesList!
                    .contains(FirebaseAuth.instance.currentUser!.uid)
                ? Colors.red
                : Colors.white,
          ),
          _buildInteractionButton(
            icon: Icons.add_comment,
            count: clickedVideoInfo.totalComments,
            onPressed: () => Get.to(
                CommentsScreen(videoID: clickedVideoInfo.videoID.toString())),
          ),
          _buildInteractionButton(
            icon: Icons.share,
            count: clickedVideoInfo.totalShares,
            onPressed: () {},
          ),
          CircularImageAnimation(
            widgetAnimation: _buildAnimatedProfileImage(clickedVideoInfo),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(dynamic clickedVideoInfo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        width: 52,
        height: 52,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            clickedVideoInfo.userProfileImage.toString(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required int count,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 40, color: color),
        ),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildAnimatedProfileImage(dynamic clickedVideoInfo) {
    return SizedBox(
      width: 62,
      height: 62,
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.grey, Colors.white]),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            clickedVideoInfo.userProfileImage.toString(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
