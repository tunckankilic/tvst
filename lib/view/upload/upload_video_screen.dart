import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tvst/view/upload/upload_form.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> getVideoFile(ImageSource sourceImg) async {
    final status = sourceImg == ImageSource.camera
        ? await Permission.camera.request()
        : await Permission.storage.request();

    if (status.isGranted) {
      try {
        final XFile? videoFile = await _picker.pickVideo(
          source: sourceImg,
          maxDuration: const Duration(minutes: 5),
        );

        if (videoFile != null) {
          final fileSize = await File(videoFile.path).length();
          if (fileSize > 100 * 1024 * 1024) {
            // 100 MB limit
            _showErrorDialog('Video size exceeds 100 MB limit');
          } else {
            Get.to(() => UploadForm(
                  videoFile: File(videoFile.path),
                  videoPath: videoFile.path,
                ));
          }
        }
      } catch (e) {
        _showErrorDialog('Error picking video: $e');
      }
    } else {
      _showErrorDialog('Permission denied');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> displayDialogBox() async {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Video Source'),
        children: [
          _buildDialogOption(
            icon: Icons.photo_library,
            text: 'Choose from Gallery',
            onPressed: () => getVideoFile(ImageSource.gallery),
          ),
          _buildDialogOption(
            icon: Icons.videocam,
            text: 'Record with Camera',
            onPressed: () => getVideoFile(ImageSource.camera),
          ),
          _buildDialogOption(
            icon: Icons.cancel,
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogOption({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        onPressed();
      },
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/upload.png",
              width: 260,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: displayDialogBox,
              icon: const Icon(Icons.cloud_upload),
              label: const Text(
                "Upload New Video",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
