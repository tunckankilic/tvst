import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tvst/view/profile/profile_controller.dart';
import 'package:tvst/view/profile/profile_screen.dart';

class FollowingScreen extends StatelessWidget {
  final String visitedProfileUserID;

  const FollowingScreen({
    Key? key,
    required this.visitedProfileUserID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: _buildAppBar(controller),
          body: FutureBuilder(
            future: controller.getFollowingListKeys(visitedProfileUserID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return _buildFollowingList(controller);
            },
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(ProfileController controller) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Column(
        children: [
          Text(
            controller.userMap["userName"] ?? "",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 2),
          Text(
            "Following ${controller.userMap["totalFollowings"] ?? 0}",
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildFollowingList(ProfileController controller) {
    if (controller.followingUsersDataList.isEmpty) {
      return const Center(
        child: Icon(Icons.person_off_sharp, color: Colors.white, size: 60),
      );
    }
    return ListView.builder(
      itemCount: controller.followingUsersDataList.length,
      itemBuilder: (context, index) {
        final following = controller.followingUsersDataList[index];
        return _buildFollowingCard(following);
      },
    );
  }

  Widget _buildFollowingCard(dynamic following) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Card(
        child: InkWell(
          onTap: () => _navigateToProfile(following["uid"]),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(following["image"] ?? ""),
            ),
            title: Text(
              following["name"] ?? "",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            subtitle: Text(
              following["email"] ?? "",
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: IconButton(
              onPressed: () => _navigateToProfile(following["uid"]),
              icon: const Icon(
                Icons.navigate_next_outlined,
                size: 24,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(String uid) {
    Get.to(() => ProfileScreen(visitUserID: uid));
  }
}
