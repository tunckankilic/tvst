import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tvst/view/inner_screens/comments/comments_screen.dart';
import 'package:tvst/view/home/following/controller_following_videos.dart';
import 'package:tvst/view/widgets/circular_image_animation.dart';
import 'package:tvst/view/widgets/custom_video_player.dart';

class FollowingsVideoScreen extends GetView<ControllerFollowingVideos> {
  const FollowingsVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.followingAllVideosList.isEmpty) {
          return const Center(child: Text('No videos available'));
        }
        return PageView.builder(
          itemCount: controller.followingAllVideosList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final eachVideoInfo = controller.followingAllVideosList[index];
            return _buildVideoItem(context, eachVideoInfo);
          },
        );
      }),
    );
  }

  Widget _buildVideoItem(BuildContext context, dynamic eachVideoInfo) {
    return Stack(
      children: [
        CustomVideoPlayer(
          videoFileUrl: eachVideoInfo.videoUrl.toString(),
          isLowDataMode: controller.isLowDataMode,
        ),
        Column(
          children: [
            const SizedBox(height: 110),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildLeftPanel(eachVideoInfo),
                  _buildRightPanel(context, eachVideoInfo),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeftPanel(dynamic eachVideoInfo) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "@${eachVideoInfo.userName}",
              style: GoogleFonts.abel(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              eachVideoInfo.descriptionTags.toString(),
              style: GoogleFonts.abel(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 6),
            _buildMusicInfo(eachVideoInfo),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicInfo(dynamic eachVideoInfo) {
    return Row(
      children: [
        Image.asset("images/music_note.png", width: 20, color: Colors.white),
        Expanded(
          child: Text(
            "  ${eachVideoInfo.artistSongName}",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.alexBrush(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel(BuildContext context, dynamic eachVideoInfo) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildProfileImage(eachVideoInfo),
          _buildLikeButton(eachVideoInfo),
          _buildCommentButton(eachVideoInfo),
          _buildShareButton(eachVideoInfo),
          _buildProfileAnimation(eachVideoInfo),
        ],
      ),
    );
  }

  Widget _buildProfileImage(dynamic eachVideoInfo) {
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
          child: Image.network(eachVideoInfo.userProfileImage.toString()),
        ),
      ),
    );
  }

  Widget _buildLikeButton(dynamic eachVideoInfo) {
    return Column(
      children: [
        IconButton(
          onPressed: () =>
              controller.likeOrUnlikeVideo(eachVideoInfo.videoID.toString()),
          icon: Icon(
            Icons.favorite_rounded,
            size: 40,
            color: eachVideoInfo.likesList!
                    .contains(FirebaseAuth.instance.currentUser!.uid)
                ? Colors.red
                : Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            eachVideoInfo.likesList!.length.toString(),
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentButton(dynamic eachVideoInfo) {
    return Column(
      children: [
        IconButton(
          onPressed: () => Get.to(
              () => CommentsScreen(videoID: eachVideoInfo.videoID.toString())),
          icon: const Icon(Icons.add_comment, size: 40, color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            eachVideoInfo.totalComments.toString(),
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(dynamic eachVideoInfo) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share, size: 40, color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            eachVideoInfo.totalShares.toString(),
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAnimation(dynamic eachVideoInfo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: CircularImageAnimation(
        widgetAnimation: Container(
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
              eachVideoInfo.userProfileImage.toString(),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
