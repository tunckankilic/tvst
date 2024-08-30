import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tvst/view/home/upload/upload_controller.dart';
import 'package:video_player/video_player.dart';
import '../../widgets/input_text_widget.dart';

class UploadForm extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const UploadForm({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final UploadController uploadVideoController = Get.put(UploadController());
  late VideoPlayerController _playerController;
  final TextEditingController _artistSongController = TextEditingController();
  final TextEditingController _descriptionTagsController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _playerController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _playerController.play();
        _playerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _playerController.dispose();
    _artistSongController.dispose();
    _descriptionTagsController.dispose();
    super.dispose();
  }

  Future<void> _uploadVideo() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUploading = true);
      try {
        await uploadVideoController.saveVideoInformationToFirestoreDatabase(
          _artistSongController.text,
          _descriptionTagsController.text,
          widget.videoPath,
          context,
        );
        Get.snackbar('Success', 'Video uploaded successfully');
        Get.back(); // Return to previous screen
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload video: $e');
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Video')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: _playerController.value.aspectRatio,
                child: VideoPlayer(_playerController),
              ),
              const SizedBox(height: 20),
              _isUploading
                  ? const SimpleCircularProgressBar(
                      progressColors: [
                        Colors.green,
                        Colors.blue,
                        Colors.red,
                        Colors.amber,
                        Colors.purple
                      ],
                      animationDuration: 20,
                      backColor: Colors.white38,
                    )
                  : Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: InputTextWidget(
                                textEditingController: _artistSongController,
                                labelText: "Artist - Song",
                                iconData: Icons.music_video_sharp,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter artist and song name';
                                  }
                                  if (value.length < 3) {
                                    return 'Artist and song name must be at least 3 characters long';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                maxLength: 100,
                                onChanged: (value) {
                                  // You can add real-time validation or other logic here
                                  setState(() {}); // Refresh the UI if needed
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: InputTextWidget(
                                textEditingController:
                                    _descriptionTagsController,
                                labelText: "Description - Tags",
                                iconData: Icons.slideshow_sharp,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter description and tags';
                                  }
                                  if (!value.contains('#')) {
                                    return 'Please include at least one tag (e.g., #music)';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                maxLength: 500,
                                onChanged: (value) {
                                  // You can add real-time validation or other logic here
                                  setState(() {}); // Refresh the UI if needed
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isUploading ? null : _uploadVideo,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          child: const Text(
                            "Upload Now",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
