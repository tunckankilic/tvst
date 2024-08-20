import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tvst/view/screens/screens_shelf.dart';

import '../view/screens/auth/auth_controller.dart';

List<Widget> pages = [
  VideoScreen(),
  const SearchScreen(),
  const AddVideoScreen(),
  ProfileScreen(uid: authController.user!.uid),
];

// // Renk paleti
// class AppColors {
//   static const Color primary = Color(0xFF00F2EA);
//   static const Color secondary = Color(0xFFFF0050);
//   static const Color background = Color(0xFF121212);
//   static const Color surface = Color(0xFF1E1E1E);
//   static const Color text = Color(0xFFFFFFFF);
//   static const Color textSecondary = Color(0xFFAAAAAA);
//   static const Color accent = Color(0xFFFFA700);
// }

// // Tema
// class AppTheme {
//   static ThemeData get theme => ThemeData(
//         primaryColor: AppColors.primary,
//         scaffoldBackgroundColor: AppColors.background,
//         colorScheme: const ColorScheme.dark(
//           primary: AppColors.primary,
//           secondary: AppColors.secondary,
//           surface: AppColors.surface,
//         ),
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           titleTextStyle: TextStyle(
//             color: AppColors.text,
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//           ),
//           iconTheme: const IconThemeData(color: AppColors.text),
//         ),
//         textTheme: TextTheme(
//           displayLarge: TextStyle(
//               color: AppColors.text,
//               fontSize: 32.sp,
//               fontWeight: FontWeight.bold),
//           displayMedium: TextStyle(
//               color: AppColors.text,
//               fontSize: 24.sp,
//               fontWeight: FontWeight.w600),
//           bodyLarge: TextStyle(color: AppColors.text, fontSize: 16.sp),
//           bodyMedium:
//               TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: AppColors.primary,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//             textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//           ),
//         ),
//       );
// }

//Shared Variables
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
AuthController authController = Get.put(AuthController());
