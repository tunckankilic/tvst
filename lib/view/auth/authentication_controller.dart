import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tvst/view/auth/login_screen.dart';
import 'package:tvst/view/home/home_bindings.dart';
import 'package:tvst/view/home/home_screen.dart';
import '../../models/user.dart' as userModel;

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final Rx<User?> _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController sEmailController = TextEditingController();
  final TextEditingController sPasswordController = TextEditingController();

  final RxBool showProgressBar = false.obs;
  final Rx<File?> _pickedFile = Rx<File?>(null);
  File? get profileImage => _pickedFile.value;

  @override
  void onInit() {
    super.onInit();
    _currentUser.bindStream(_auth.authStateChanges());
    ever(_currentUser, _handleAuthStateChanges);
  }

  void _handleAuthStateChanges(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  Future<void> chooseImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _pickedFile.value = File(pickedImage.path);
      Get.snackbar("Profile Image", "Image selected successfully.");
    }
  }

  Future<void> captureImageWithCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      _pickedFile.value = File(pickedImage.path);
      Get.snackbar("Profile Image", "Image captured successfully.");
    }
  }

  Future<void> createAccountForNewUser(File imageFile, String userName,
      String userEmail, String userPassword) async {
    try {
      showProgressBar.value = true;

      // Validate input
      if (!_validateInput(userName, userEmail, userPassword)) {
        return;
      }

      // Create user in Firebase Authentication
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      // Upload profile image
      final String imageDownloadUrl =
          await _uploadImageToStorage(imageFile, credential.user!.uid);

      // Save user data to Firestore
      final userModel.User user = userModel.User(
        name: userName,
        email: userEmail,
        image: imageDownloadUrl,
        uid: credential.user!.uid,
      );

      try {
        await _firestore
            .collection("users")
            .doc(credential.user!.uid)
            .set(user.toJson());

        DocumentSnapshot docSnap = await _firestore
            .collection("users")
            .doc(credential.user!.uid)
            .get();
        if (docSnap.exists) {
          print("User saved successfully!");

          // Navigate to HomeScreen only after successful signup
          Get.offAll(() => const HomeScreen(), binding: HomeBindings());
        } else {
          Get.snackbar("Error", "User data could not be saved.");
        }
      } catch (firestoreError) {
        print("Firestore error: $firestoreError");
        Get.snackbar(
            "Firestore Error", "User data could not be saved: $firestoreError");
      }
    } catch (error) {
      Get.snackbar("Signup Failed", "Error: $error");
    } finally {
      showProgressBar.value = false;
    }
  }

  bool _validateInput(String userName, String email, String password) {
    if (userName.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Invalid Input", "Please fill in all fields.");
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Invalid Email", "Please enter a valid email address.");
      return false;
    }
    if (password.length < 6) {
      Get.snackbar(
          "Weak Password", "Password should be at least 6 characters long.");
      return false;
    }
    return true;
  }

  Future<String> _uploadImageToStorage(File imageFile, String uid) async {
    final Reference reference =
        _storage.ref().child("Profile Images").child(uid);
    final UploadTask uploadTask = reference.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> loginUserNow(String userEmail, String userPassword) async {
    try {
      showProgressBar.value = true;

      // Perform sign in with email and password
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      // Check if user data exists in Firestore
      final DocumentSnapshot docSnap =
          await _firestore.collection("users").doc(credential.user!.uid).get();
      if (docSnap.exists) {
        // If the user exists in Firestore, navigate to the HomeScreen
        Get.snackbar("Login Successful", "You have logged in successfully.");
        Get.offAll(() => const HomeScreen(), binding: HomeBindings());
      } else {
        // If user data does not exist in Firestore, show an error
        Get.snackbar("Error", "User data does not exist in the database.");
      }
    } catch (error) {
      // Handle any errors that occur during login
      Get.snackbar("Login Failed", "Error: $error");
    } finally {
      showProgressBar.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    sEmailController.dispose();
    sPasswordController.dispose();
    super.onClose();
  }
}
