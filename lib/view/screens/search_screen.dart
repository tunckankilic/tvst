import 'package:flutter/material.dart';
import 'package:tvst/models/user.dart';
import 'package:tvst/view/screens/screens_shelf.dart';
import 'package:get/get.dart';
import 'package:tvst/controllers/search_controller.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(SearchScreenController());
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            decoration: const InputDecoration(
              filled: false,
              hintText: 'Search',
              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onFieldSubmitted: (value) => controller.searchUser(value),
          ),
        ),
        body: controller.searchedUsers.isEmpty
            ? const Center(
                child: Text(
                  'Search for users!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: controller.searchedUsers.length,
                itemBuilder: (context, index) {
                  User user = controller.searchedUsers[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: user.uid),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profilePhoto,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
