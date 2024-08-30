import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tvst/global.dart';
import 'package:tvst/view/auth/authentication_bindings.dart';
import 'package:tvst/view/auth/login_screen.dart';
import 'package:tvst/view/home/following/followings_video_screen.dart';
import 'package:tvst/view/home/for_you/for_you_video_screen.dart';
import 'package:tvst/view/home/profile/profile_screen.dart';
import 'package:tvst/view/home/search/search_screen.dart';
import 'package:tvst/view/widgets/upload_custom_icon.dart';
import 'package:tvst/view/home/upload/upload_video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;
  List screensList = [
    const ForYouVideoScreen(),
    const SearchScreen(),
    const UploadVideoScreen(),
    const FollowingsVideoScreen(),
    ProfileScreen(
      visitUserID: currentUserID,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            screenIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white12,
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: "Discover"),
          BottomNavigationBarItem(icon: UploadCustomIcon(), label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.inbox_sharp,
                size: 30,
              ),
              label: "Following"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: "Me"),
        ],
      ),
      body: screensList[screenIndex],
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   await FirebaseAuth.instance.signOut();
      //   Get.to(LoginScreen());
      // }),
    );
  }
}
