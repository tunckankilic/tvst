import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvst/models/user.dart';
import 'package:tvst/view/screens/screens_shelf.dart';
import 'package:get/get.dart';
import 'package:tvst/view/screens/search/search_controller.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchScreenController());
    return Scaffold(
      appBar: _buildSearchAppBar(context),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
        } else if (controller.searchedUsers.isEmpty && controller.hasSearched) {
          return _buildNoResultsFound(context);
        } else if (!controller.hasSearched) {
          return _buildInitialSearchState(context);
        } else {
          return _buildSearchResults(context);
        }
      }),
    );
  }

  PreferredSizeWidget _buildSearchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: 'Search for users',
          hintStyle: TextStyle(
              fontSize: 16.sp, color: Theme.of(context).secondaryHeaderColor),
          prefixIcon:
              Icon(Icons.search, color: Theme.of(context).secondaryHeaderColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
        style: TextStyle(fontSize: 16.sp, color: Theme.of(context).cardColor),
        onChanged: (value) => controller.searchUser(value),
      ),
    );
  }

  Widget _buildNoResultsFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 80.sp, color: Theme.of(context).secondaryHeaderColor),
          SizedBox(height: 20.h),
          Text(
            'No users found',
            style: TextStyle(
                fontSize: 20.sp,
                color: Theme.of(context).cardColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialSearchState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search,
              size: 80.sp, color: Theme.of(context).primaryColor),
          SizedBox(height: 20.h),
          Text(
            'Search for users!',
            style: TextStyle(
                fontSize: 20.sp,
                color: Theme.of(context).cardColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
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
                color: Theme.of(context).cardColor,
                fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            '@${user.name}',
            style: TextStyle(
                fontSize: 14.sp, color: Theme.of(context).secondaryHeaderColor),
          ),
          trailing: IconButton(
            icon: Icon(Icons.person_add, color: Theme.of(context).primaryColor),
            onPressed: () => controller.followUser(user.uid),
          ),
          onTap: () => Get.to(() => ProfileScreen(uid: user.uid)),
        );
      },
    );
  }
}
