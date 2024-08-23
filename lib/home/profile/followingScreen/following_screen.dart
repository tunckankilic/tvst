import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tvst/home/profile/profile_controller.dart';

import '../profile_screen.dart';

class FollowingScreen extends GetView<ProfileController> {
  String visitedProfileUserID;

  FollowingScreen({
    required this.visitedProfileUserID,
  });

  @override
  Widget build(BuildContext context) {
    controller.getFollowingListKeys(visitedProfileUserID);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            Text(
              controller.userMap["userName"],
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "Following " + controller.userMap["totalFollowings"],
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: controller.followingUsersDataList.isEmpty
          ? const Center(
              child: Icon(
                Icons.person_off_sharp,
                color: Colors.white,
                size: 60,
              ),
            )
          : ListView.builder(
              itemCount: controller.followingUsersDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Get.to(ProfileScreen(
                          visitUserID: controller.followingUsersDataList[index]
                              ["uid"],
                        ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(controller
                              .followingUsersDataList[index]["image"]
                              .toString()),
                        ),
                        title: Text(
                          controller.followingUsersDataList[index]["name"]
                              .toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          controller.followingUsersDataList[index]["email"]
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Get.to(ProfileScreen(
                              visitUserID: controller
                                  .followingUsersDataList[index]["uid"],
                            ));
                          },
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
              },
            ),
    );
  }
}
