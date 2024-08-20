import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvst/view/screens/screens_shelf.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  Future<void> pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Get.to(
        () => ConfirmScreen(
          videoFile: File(video.path),
          videoPath: video.path,
        ),
        transition: Transition.rightToLeft,
      );
    }
  }

  void showOptionsDialog(BuildContext context) {
    Get.dialog(
      SimpleDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        children: [
          _buildDialogOption(
            context: context,
            icon: Icons.photo_library_rounded,
            label: 'Gallery',
            onPressed: () => pickVideo(ImageSource.gallery, context),
          ),
          _buildDialogOption(
            context: context,
            icon: Icons.camera_alt_rounded,
            label: 'Camera',
            onPressed: () => pickVideo(ImageSource.camera, context),
          ),
          _buildDialogOption(
            context: context,
            icon: Icons.close_rounded,
            label: 'Cancel',
            onPressed: () => Get.back(),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildDialogOption({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return SimpleDialogOption(
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 28.sp),
          SizedBox(width: 14.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor
            ],
          ),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () => showOptionsDialog(context),
            child: Container(
              width: 200.w,
              height: 60.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).secondaryHeaderColor
                  ],
                ),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    spreadRadius: 1.r,
                    blurRadius: 18.r,
                    offset: Offset(0, 7.h),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Add Video',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).cardColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
