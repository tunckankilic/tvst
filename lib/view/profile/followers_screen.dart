import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tvst/view/profile/profile_controller.dart';
import 'package:tvst/view/profile/profile_screen.dart';

class FollowersScreen extends StatelessWidget {
  final String visitedProfileUserID;

  const FollowersScreen({
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
            future: controller.getFollowersListKeys(visitedProfileUserID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return _buildFollowersList(controller);
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
            "Followers ${controller.userMap["totalFollowers"] ?? 0}",
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildFollowersList(ProfileController controller) {
    if (controller.followerUsersDataList.isEmpty) {
      return const Center(
        child: Icon(Icons.person_off_sharp, color: Colors.white, size: 60),
      );
    }
    return ListView.builder(
      itemCount: controller.followerUsersDataList.length,
      itemBuilder: (context, index) {
        final follower = controller.followerUsersDataList[index];
        return _buildFollowerCard(follower, controller);
      },
    );
  }

  Widget _buildFollowerCard(dynamic follower, ProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Card(
        child: InkWell(
          onTap: () => _navigateToProfile(follower["uid"]),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(follower["image"] ?? ""),
            ),
            title: Text(
              follower["name"] ?? "",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            subtitle: Text(
              follower["email"] ?? "",
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: IconButton(
              onPressed: () => _navigateToProfile(follower["uid"]),
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
