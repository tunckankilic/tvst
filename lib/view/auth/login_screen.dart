import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                _buildLogo(),
                _buildWelcomeText(),
                const SizedBox(height: 30),
                _buildEmailInput(),
                const SizedBox(height: 20),
                _buildPasswordInput(),
                const SizedBox(height: 30),
                _buildLoginButton(),
                const SizedBox(height: 15),
                _buildSignUpPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset("images/tiktok.png", width: 150);
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          "Welcome",
          style: GoogleFonts.acme(
              fontSize: 34, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        Text(
          "Glad to see you!",
          style: GoogleFonts.acme(fontSize: 28, color: Colors.grey),
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

  Widget _buildLoginButton() {
    return Obx(
      () => controller.showProgressBar.value
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            ),
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

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an Account? ",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        GestureDetector(
          onTap: () => Get.to(() => const RegistrationScreen()),
          child: const Text(
            "Sign Up Now",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
