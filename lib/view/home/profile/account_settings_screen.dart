import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tvst/view/home/profile/profile_controller.dart';
import 'package:tvst/view/widgets/input_text_widget.dart';

class AccountSettingsScreen extends GetView<ProfileController> {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controllerProfile) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              "Account Settings",
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
            centerTitle: true,
          ),
          body: FutureBuilder(
            future: controllerProfile.getCurrentUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileImage(controllerProfile),
                    const SizedBox(height: 30),
                    const Text(
                      "Update your profile social links:",
                      style: TextStyle(fontSize: 22, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildSocialInputs(controllerProfile, context),
                    const SizedBox(height: 30),
                    _buildUpdateButton(controllerProfile),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(ProfileController controller) {
    return GestureDetector(
      onTap: () => controller.updateProfileImage(),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(controller.userMap["userImage"]),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.edit, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialInputs(
      ProfileController controller, BuildContext context) {
    final socialInputs = [
      {
        'label': 'facebook.com/username',
        'asset': 'images/facebook.png',
        'controller': controller.facebookTextEditingController
      },
      {
        'label': 'm.youtube.com/c/username',
        'asset': 'images/youtube.png',
        'controller': controller.youtubeTextEditingController
      },
      {
        'label': 'instagram.com/username',
        'asset': 'images/instagram.png',
        'controller': controller.instagramTextEditingController
      },
      {
        'label': 'twitter.com/username',
        'asset': 'images/twitter.png',
        'controller': controller.twitterTextEditingController
      },
    ];

    return Column(
      children: socialInputs
          .map((input) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: InputTextWidget(
                  textEditingController:
                      input['controller'] as TextEditingController,
                  labelText: input['label'] as String,
                  assetReference: input['asset'] as String,
                  isObscure: false,
                  keyboardType: TextInputType.url,
                  validator: (value) =>
                      _validateUrl(value, input['label'] as String),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildUpdateButton(ProfileController controller) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: () {
        if (_validateAllInputs(controller)) {
          controller.updateUserSocialAccountLinks(
            controller.facebookTextEditingController.text,
            controller.youtubeTextEditingController.text,
            controller.twitterTextEditingController.text,
            controller.instagramTextEditingController.text,
          );
          Get.snackbar('Success', 'Profile updated successfully');
        } else {
          Get.snackbar('Error', 'Please enter valid URLs');
        }
      },
      child: const Text(
        "Update Now",
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String? _validateUrl(String? value, String platform) {
    if (value == null || value.isEmpty) return null;
    if (!value.startsWith('https://') && !value.startsWith('http://')) {
      return 'Please enter a valid $platform URL';
    }
    return null;
  }

  bool _validateAllInputs(ProfileController controller) {
    return _validateUrl(
                controller.facebookTextEditingController.text, 'Facebook') ==
            null &&
        _validateUrl(controller.youtubeTextEditingController.text, 'YouTube') ==
            null &&
        _validateUrl(
                controller.instagramTextEditingController.text, 'Instagram') ==
            null &&
        _validateUrl(controller.twitterTextEditingController.text, 'Twitter') ==
            null;
  }
}
