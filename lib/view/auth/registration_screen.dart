import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tvst/view/auth/authentication_controller.dart';
import 'package:tvst/view/auth/login_screen.dart';
import 'package:tvst/view/widgets/input_text_widget.dart';

class RegistrationScreen extends GetView<AuthenticationController> {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildProfileAvatar(),
                const SizedBox(height: 30),
                _buildInputFields(),
                const SizedBox(height: 30),
                _buildSignUpButton(),
                const SizedBox(height: 15),
                _buildLoginPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Create Account",
          style: GoogleFonts.acme(
              fontSize: 34, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        Text(
          "to get Started Now!",
          style: GoogleFonts.acme(fontSize: 28, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Obx(() => GestureDetector(
          onTap: () => controller.chooseImageFromGallery(),
          child: CircleAvatar(
            radius: 80,
            backgroundImage: controller.profileImage != null
                ? FileImage(controller.profileImage!)
                : const AssetImage("images/profile_avatar.jpg")
                    as ImageProvider,
            backgroundColor: Colors.black,
          ),
        ));
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        InputTextWidget(
          textEditingController: controller.userNameController,
          labelText: "Username",
          iconData: Icons.person_outline,
          isObscure: false,
        ),
        const SizedBox(height: 20),
        InputTextWidget(
          textEditingController: controller.sEmailController,
          labelText: "Email",
          iconData: Icons.email_outlined,
          isObscure: false,
        ),
        const SizedBox(height: 20),
        InputTextWidget(
          textEditingController: controller.sPasswordController,
          labelText: "Password",
          iconData: Icons.lock_outline,
          isObscure: true,
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Obx(
      () => controller.showProgressBar.value
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            ),
    );
  }

  void _handleSignUp() {
    if (controller.profileImage != null &&
        controller.userNameController.text.isNotEmpty &&
        controller.sEmailController.text.isNotEmpty &&
        controller.sPasswordController.text.isNotEmpty) {
      controller.showProgressBar.value = true;
      controller.createAccountForNewUser(
        controller.profileImage!,
        controller.userNameController.text,
        controller.sEmailController.text,
        controller.sPasswordController.text,
      );
    } else {
      Get.snackbar(
          "Error", "Please fill in all fields and select a profile image");
    }
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        GestureDetector(
          onTap: () => Get.to(() => const LoginScreen()),
          child: const Text(
            "Login Now",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
