import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tvst/home/profile/profile_controller.dart';

import '../profile_screen.dart';

class FollowersScreen extends GetView<ProfileController> {
  final String visitedProfileUserID;

  FollowersScreen({
    required this.visitedProfileUserID,
  });

  @override
  Widget build(BuildContext context) {
    controller.getFollowersListKeys(visitedProfileUserID);
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
              "Followers ${controller.userMap["totalFollowers"]}",
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: controller.followerUsersDataList.isEmpty
          ? const Center(
              child: Icon(
                Icons.person_off_sharp,
                color: Colors.white,
                size: 60,
              ),
            )
          : ListView.builder(
              itemCount: controller.followerUsersDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Get.to(ProfileScreen(
                          visitUserID: controller.followerUsersDataList[index]
                              ["uid"],
                        ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(controller
                              .followerUsersDataList[index]["image"]
                              .toString()),
                        ),
                        title: Text(
                          controller.followerUsersDataList[index]["name"]
                              .toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          controller.followerUsersDataList[index]["email"]
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Get.to(ProfileScreen(
                              visitUserID: controller
                                  .followerUsersDataList[index]["uid"],
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
