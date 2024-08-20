import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tvst/consts/consts_shelf.dart';
import 'package:tvst/view/screens/profile/profile_controller.dart';
import 'package:tvst/view/screens/screens_shelf.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  void _handleNavigation() {
    if (widget.uid == authController.user!.uid) {
      // Eğer bu kullanıcının kendi profili ise
      Get.back();
    } else {
      // Eğer başka bir kullanıcının profili ise
      if (Get.previousRoute.isNotEmpty) {
        Get.back();
      } else {
        // Eğer önceki sayfa yoksa (direkt bu sayfaya gelindiyse), ana sayfaya yönlendir
        Get.offAll(
          () => const HomeScreen(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: widget.uid == authController.user!.uid
                ? IconButton(
                    icon: Icon(Icons.arrow_back, size: 24.sp),
                    onPressed: _handleNavigation,
                  )
                : const SizedBox.shrink(),
            actions: [Icon(Icons.more_horiz, size: 24.sp)],
            title: Text(
              controller.user['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 18.sp,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildProfileInfo(controller),
                  SizedBox(height: 20.h),
                  _buildActionButton(controller),
                  SizedBox(height: 20.h),
                  _buildVideoGrid(controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInfo(ProfileController controller) {
    return Column(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: controller.user['profilePhoto'],
            height: 100.r,
            width: 100.r,
            placeholder: (context, url) => CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
            errorWidget: (context, url, error) => Icon(Icons.error,
                size: 50.sp, color: Theme.of(context).secondaryHeaderColor),
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatColumn('Following', controller.user['following']),
            _buildDivider(),
            _buildStatColumn('Followers', controller.user['followers']),
            _buildDivider(),
            _buildStatColumn('Likes', controller.user['likes']),
          ],
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: 5.h),
        Text(
          label,
          style: TextStyle(
              fontSize: 14.sp, color: Theme.of(context).secondaryHeaderColor),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
      width: 1.w,
      height: 15.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
    );
  }

  Widget _buildActionButton(ProfileController controller) {
    return Container(
      width: 140.w,
      height: 47.h,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Center(
        child: InkWell(
          onTap: () {
            if (widget.uid == authController.user!.uid) {
              authController.signOut();
            } else {
              controller.followUser();
            }
          },
          child: Text(
            widget.uid == authController.user!.uid
                ? 'Sign Out'
                : controller.user['isFollowing']
                    ? 'Unfollow'
                    : 'Follow',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoGrid(ProfileController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.user['thumbnails'].length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 5.w,
        mainAxisSpacing: 5.h,
      ),
      itemBuilder: (context, index) {
        String thumbnail = controller.user['thumbnails'][index];
        return CachedNetworkImage(
          imageUrl: thumbnail,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Container(color: Theme.of(context).scaffoldBackgroundColor),
          errorWidget: (context, url, error) =>
              Icon(Icons.error, color: Theme.of(context).secondaryHeaderColor),
        );
      },
    );
  }
}
