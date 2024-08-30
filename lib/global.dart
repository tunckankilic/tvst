import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

RxBool showProgressBar = false.obs;
String currentUserID = FirebaseAuth.instance.currentUser!.uid.toString();
