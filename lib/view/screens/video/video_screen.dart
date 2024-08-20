import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvst/consts/consts_shelf.dart';
import 'package:tvst/view/screens/comment/comment_bindings.dart';
import 'package:tvst/view/screens/video/video_controller.dart';
import 'package:tvst/view/screens/comment/screens/comment_screen.dart';
import 'package:tvst/view/shared/circle_animation.dart';
import 'package:tvst/view/shared/video_player_item.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});

  final VideoController videoController = Get.put(VideoController());

  Widget buildProfile(String profilePhoto, BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).primaryColor, width: 2.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.w),
        child: Image.network(
          profilePhoto,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildMusicAlbum(String profilePhoto, BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.w,
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).primaryColor
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.w),
        child: Image.network(
          profilePhoto,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return Stack(
              children: [
                VideoPlayerItem(videoUrl: data.videoUrl),
                Column(
                  children: [
                    SizedBox(height: 100.h),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    data.username,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: Theme.of(context).cardColor),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    data.caption,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Theme.of(context).cardColor),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Icon(Icons.music_note,
                                          size: 15.w,
                                          color:
                                              Theme.of(context).primaryColor),
                                      SizedBox(width: 5.w),
                                      Text(
                                        data.songName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .cardColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100.w,
                            margin: EdgeInsets.only(top: 0.2.sh),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfile(data.profilePhoto, context),
                                SizedBox(height: 20.h),
                                _buildInteractionButton(
                                  context: context,
                                  icon: Icons.favorite,
                                  count: data.likes.length,
                                  color: data.likes
                                          .contains(authController.user!.uid)
                                      ? Theme.of(context).secondaryHeaderColor
                                      : Theme.of(context).cardColor,
                                  onTap: () =>
                                      videoController.likeVideo(data.id),
                                ),
                                SizedBox(height: 20.h),
                                _buildInteractionButton(
                                  context: context,
                                  icon: Icons.comment,
                                  count: data.commentCount,
                                  color: Theme.of(context).cardColor,
                                  onTap: () => Get.to(
                                      () => CommentScreen(id: data.id),
                                      binding: CommentBindings()),
                                ),
                                SizedBox(height: 20.h),
                                CircleAnimation(
                                    child: buildMusicAlbum(
                                        data.profilePhoto, context)),
                              ],
                            ),
                          ),
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
    );
  }

  Widget _buildInteractionButton(
      {required IconData icon,
      required int count,
      required Color color,
      required VoidCallback onTap,
      required BuildContext context}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Icon(icon, size: 40.w, color: color),
        ),
        SizedBox(height: 7.h),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 20.sp, color: Theme.of(context).cardColor),
        )
      ],
    );
  }
}
