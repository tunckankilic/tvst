import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvst/view/screens/upload_video/upload_video_controller.dart';
import 'package:tvst/view/screens/screens_shelf.dart';
import 'package:tvst/view/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({
    super.key,
    required this.videoFile,
    required this.videoPath,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  late VideoPlayerController controller;
  final UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.play();
        controller.setVolume(1);
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Confirm Video',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).cardColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).cardColor, size: 24.sp),
          onPressed: () => Get.back(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildVideoPlayer(),
            _buildInputFields(),
            _buildShareButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      height: 0.6.sh,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 3.w,
                ),
              ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          TextInputField(
            textEditingController: _songController,
            label: 'Song Name',
            iconData: Icons.music_note,
          ),
          SizedBox(height: 20.h),
          TextInputField(
            textEditingController: _captionController,
            label: 'Caption',
            iconData: Icons.closed_caption,
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: ElevatedButton(
        onPressed: () => _shareVideo(),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
        ),
        child: Text(
          'Share!',
          style: TextStyle(
            fontSize: 20.sp,
            color: Theme.of(context).cardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _shareVideo() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Uploading Video',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                value: uploadVideoController.overallProgress,
                color: Theme.of(context).primaryColor,
                strokeWidth: 3.w,
              ),
              SizedBox(height: 20.h),
              Text(
                'Overall Progress: ${(uploadVideoController.overallProgress * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                'Compression: ${(uploadVideoController.progressCompression * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                'Upload: ${(uploadVideoController.progressUpload * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          );
        }),
      ),
      barrierDismissible: false,
    );

    uploadVideoController
        .uploadVideo(
      _songController.text,
      _captionController.text,
      widget.videoPath,
    )
        .then((_) {
      Get.back(); // Dismiss the loading dialog
      Get.snackbar(
        'Success',
        'Your video has been shared!',
        backgroundColor: Theme.of(context).primaryColor,
        colorText: Theme.of(context).cardColor,
        snackPosition: SnackPosition.TOP,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.all(8.w),
      );
      Get.offAll(() => const HomeScreen()); // Navigate back to home screen
    }).catchError((error) {
      Get.back(); // Dismiss the loading dialog
      Get.snackbar(
        'Error',
        'Failed to upload video. Please try again.',
        backgroundColor: Colors.red,
        colorText: Theme.of(context).cardColor,
        snackPosition: SnackPosition.TOP,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.all(8.w),
      );
    });
  }
}
