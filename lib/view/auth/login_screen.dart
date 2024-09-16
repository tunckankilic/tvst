import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tvst/consts/theme.dart';
import 'package:tvst/view/auth/registration_screen.dart';
import 'package:tvst/view/widgets/input_text_widget.dart';
import 'authentication_controller.dart';

class LoginScreen extends GetView<AuthenticationController> {
  const LoginScreen({Key? key}) : super(key: key);

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
                _buildWelcomeText(),
                const SizedBox(height: 30),
                _buildEmailInput(),
                const SizedBox(height: 20),
                _buildPasswordInput(),
                const SizedBox(height: 30),
                _buildLoginButton(context),
                const SizedBox(height: 15),
                _buildSignUpPrompt(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Obx(
      () => controller.showProgressBar.value
          ? CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary)
          : ElevatedButton(
              onPressed: _handleLogin,
              child: Text(
                "Login",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ),
    );
  }

  Widget _buildSignUpPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an Account? ",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
        GestureDetector(
          onTap: () => Get.to(() => const RegistrationScreen()),
          child: Text(
            "Sign Up Now",
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundImage: AssetImage("images/512.png"),
        ),
        SizedBox(height: 16.h),
        Text(
          "Welcome to TVST",
          style: GoogleFonts.poppins(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailInput() {
    return InputTextWidget(
      textEditingController: controller.emailController,
      labelText: "Email",
      iconData: Icons.email_outlined,
      isObscure: false,
    );
  }

  Widget _buildPasswordInput() {
    return InputTextWidget(
      textEditingController: controller.passwordController,
      labelText: "Password",
      iconData: Icons.lock_outline,
      isObscure: true,
    );
  }

  void _handleLogin() {
    if (controller.emailController.text.isNotEmpty &&
        controller.passwordController.text.isNotEmpty) {
      controller.showProgressBar.value = true;
      controller.loginUserNow(
        controller.emailController.text,
        controller.passwordController.text,
      );
    } else {
      Get.snackbar("Error", "Please fill in all fields");
    }
  }
}
