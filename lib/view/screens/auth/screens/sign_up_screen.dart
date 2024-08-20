import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tvst/consts/consts_shelf.dart';
import 'package:tvst/view/screens/auth/screens/auth_shelf.dart';
import 'package:tvst/view/widgets/text_input_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                _buildLogo(context),
                SizedBox(height: 30.h),
                _buildProfilePicture(context),
                SizedBox(height: 20.h),
                _buildInputFields(),
                SizedBox(height: 30.h),
                _buildRegisterButton(context),
                SizedBox(height: 20.h),
                _buildLoginLink(context),
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
          'Register',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 64.r,
          backgroundImage: const NetworkImage(
              'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        Positioned(
          bottom: -10,
          left: 80,
          child: IconButton(
            onPressed: () => authController.pickImage(),
            icon: Icon(Icons.add_a_photo,
                size: 30.sp, color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        TextInputField(
          textEditingController: _usernameController,
          label: 'Username',
          iconData: Icons.person,
        ),
        SizedBox(height: 15.h),
        TextInputField(
          textEditingController: _emailController,
          label: 'Email',
          iconData: Icons.email,
        ),
        SizedBox(height: 15.h),
        TextInputField(
          textEditingController: _passwordController,
          label: 'Password',
          iconData: Icons.lock,
          isObs: true,
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _registerUser(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        padding: EdgeInsets.symmetric(vertical: 15.h),
        minimumSize: Size(1.sw - 40.w, 50.h),
      ),
      child: Text(
        'Register',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.bodySmall?.color),
        ),
        GestureDetector(
          onTap: () => Get.off(() => LoginScreen()),
          child: Text(
            'Login',
            style: TextStyle(
                fontSize: 16.sp,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _registerUser() {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all the fields');
      return;
    }
    authController.registerUser(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
      authController.profilePhoto,
    );
  }
}
