import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tvst/consts/consts_shelf.dart';
import 'package:tvst/models/video.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

class UploadVideoController extends GetxController {
  final Rx<double> _progressCompression = 0.0.obs;
  final Rx<double> _progressUpload = 0.0.obs;
  final Rx<double> _overallProgress = 0.0.obs;

  double get progressCompression => _progressCompression.value;
  double get progressUpload => _progressUpload.value;
  double get overallProgress => _overallProgress.value;

  Future<File?> _compressVideo(String videoPath) async {
    final Directory extDir = await getTemporaryDirectory();
    final outputPath = '${extDir.path}/output.mp4';

    final arguments = [
      '-i',
      videoPath,
      '-c:v',
      'libx264',
      '-crf',
      '23',
      '-preset',
      'medium',
      '-c:a',
      'aac',
      '-b:a',
      '128k',
      outputPath
    ];

    final session = await FFmpegKit.execute(arguments.join(' '));
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      _progressCompression.value = 1.0;
      _updateOverallProgress();
      return File(outputPath);
    } else {
      final logs = await session.getLogs();
      throw Exception('Video compression failed: ${logs.last.getMessage()}');
    }
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    final compressedVideoFile = await _compressVideo(videoPath);
    if (compressedVideoFile == null) {
      throw Exception('Video compression failed');
    }

    UploadTask uploadTask = ref.putFile(compressedVideoFile);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      _progressUpload.value = snapshot.bytesTransferred / snapshot.totalBytes;
      _updateOverallProgress();
    });

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail.path;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    String thumbnailPath = await _getThumbnail(videoPath);
    UploadTask uploadTask = ref.putFile(File(thumbnailPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void _updateOverallProgress() {
    _overallProgress.value =
        (_progressCompression.value * 0.3) + (_progressUpload.value * 0.7);
  }

  Future<void> uploadVideo(
      String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;

      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
      );

      await firestore
          .collection('videos')
          .doc('Video $len')
          .set(video.toJson());
      Get.back();
    } catch (e) {
      Get.snackbar('Error Uploading Video', e.toString());
    } finally {
      _progressCompression.value = 0.0;
      _progressUpload.value = 0.0;
      _overallProgress.value = 0.0;
    }
  }
}
