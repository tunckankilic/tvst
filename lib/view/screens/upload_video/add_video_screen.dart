import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvst/view/screens/screens_shelf.dart';
import '../../../consts/consts_shelf.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

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
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        children: [
          _buildDialogOption(
            icon: Icons.photo_library_rounded,
            label: 'Gallery',
            onPressed: () => pickVideo(ImageSource.gallery, context),
          ),
          _buildDialogOption(
            icon: Icons.camera_alt_rounded,
            label: 'Camera',
            onPressed: () => pickVideo(ImageSource.camera, context),
          ),
          _buildDialogOption(
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
  }) {
    return SimpleDialogOption(
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 28.sp),
          SizedBox(width: 14.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.text,
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
            colors: [AppColors.background, AppColors.surface],
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
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
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
                        color: AppColors.text,
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
