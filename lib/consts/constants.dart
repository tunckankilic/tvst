import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tvst/view/screens/screens_shelf.dart';

import '../view/screens/auth/auth_controller.dart';

List<Widget> pages = [
  VideoScreen(),
  const SearchScreen(),
  const AddVideoScreen(),
  ProfileScreen(uid: authController.user!.uid),
];

//Shared Variables
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
AuthController authController = Get.put(AuthController());
