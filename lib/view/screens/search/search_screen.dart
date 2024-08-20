import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvst/models/user.dart';
import 'package:tvst/view/screens/screens_shelf.dart';
import 'package:get/get.dart';
import 'package:tvst/consts/consts_shelf.dart';
import 'package:tvst/view/screens/search/search_controller.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SearchScreenController());
    return Scaffold(
      appBar: _buildSearchAppBar(),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        } else if (controller.searchedUsers.isEmpty && controller.hasSearched) {
          return _buildNoResultsFound();
        } else if (!controller.hasSearched) {
          return _buildInitialSearchState();
        } else {
          return _buildSearchResults();
        }
      }),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          hintText: 'Search for users',
          hintStyle: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
        style: TextStyle(fontSize: 16.sp, color: AppColors.text),
        onChanged: (value) => controller.searchUser(value),
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80.sp, color: AppColors.textSecondary),
          SizedBox(height: 20.h),
          Text(
            'No users found',
            style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.text,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialSearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80.sp, color: AppColors.primary),
          SizedBox(height: 20.h),
          Text(
            'Search for users!',
            style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.text,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: controller.searchedUsers.length,
      itemBuilder: (context, index) {
        User user = controller.searchedUsers[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: CircleAvatar(
            radius: 25.r,
            backgroundImage: NetworkImage(user.profilePhoto),
          ),
          title: Text(
            user.name,
            style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.text,
                fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            '@${user.name}',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          trailing: IconButton(
            icon: Icon(Icons.person_add, color: AppColors.primary),
            onPressed: () => controller.followUser(user.uid),
          ),
          onTap: () => Get.to(() => ProfileScreen(uid: user.uid)),
        );
      },
    );
  }
}
