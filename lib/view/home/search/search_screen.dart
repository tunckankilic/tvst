import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tvst/view/home/profile/profile_screen.dart';
import 'package:tvst/view/home/search/search_controller.dart' as sa;
import 'package:tvst/models/user.dart';

class SearchScreen extends GetView<sa.SearchController> {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody(context)),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 6,
      backgroundColor: Colors.black54,
      title: _buildSearchField(),
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white70, width: 2.0),
          borderRadius: BorderRadius.circular(6.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white70, width: 2.0),
          borderRadius: BorderRadius.circular(6.0),
        ),
        hintText: "Search here...",
        hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
      onChanged: (textInput) {
        controller.searchForUser(textInput);
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return controller.usersSearchedList.isEmpty
        ? _buildEmptyState(context)
        : _buildSearchResults();
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
        child: Text(
      "There is no Search Results",
      style: Theme.of(context).textTheme.displaySmall,
    ));
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: controller.usersSearchedList.length,
      itemBuilder: (context, index) {
        User eachSearchedUserRecord = controller.usersSearchedList[index];
        return _buildUserCard(eachSearchedUserRecord);
      },
    );
  }

  Widget _buildUserCard(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Card(
        child: InkWell(
          onTap: () => _navigateToProfile(user.uid),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.image ?? ""),
            ),
            title: Text(
              user.name ?? "",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            subtitle: Text(
              user.email ?? "",
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: IconButton(
              onPressed: () => _navigateToProfile(user.uid),
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

  void _navigateToProfile(String? uid) {
    if (uid != null) {
      Get.to(() => ProfileScreen(visitUserID: uid));
    }
  }
}
