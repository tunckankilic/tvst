import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tvst/view/screens/auth/auth_controller.dart';
import 'package:tvst/view/screens/auth/screens/auth_shelf.dart';
import 'package:tvst/view/widgets/text_input_field.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                _buildLogo(context),
                SizedBox(height: 50.h),
                _buildEmailField(),
                SizedBox(height: 20.h),
                _buildPasswordField(),
                SizedBox(height: 40.h),
                _buildLoginButton(context),
                SizedBox(height: 20.h),
                _buildSignUpLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Column(
      children: [
        Text(
          'TVST',
          style: TextStyle(
            fontSize: 40.sp,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Login',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextInputField(
      textEditingController: controller.emailController!,
      label: 'Email',
      iconData: Icons.email,
    );
  }

  Widget _buildPasswordField() {
    return TextInputField(
      textEditingController: controller.passwordController!,
      label: 'Password',
      iconData: Icons.lock,
      isObs: true,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.loginUser(
        controller.emailController!.text,
        controller.passwordController!.text,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        minimumSize: Size(1.sw - 40.w, 50.h),
      ),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: TextStyle(
            fontSize: 16.sp,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(() => SignupScreen()),
          child: Text(
            'Register',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
