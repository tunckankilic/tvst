// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoFileUrl;
  final RxBool isLowDataMode;

  const CustomVideoPlayer({
    Key? key,
    required this.videoFileUrl,
    required this.isLowDataMode,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? playerController;

  @override
  void initState() {
    super.initState();
    playerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoFileUrl))
          ..initialize().then((value) {
            playerController!.play();
            playerController!.setLooping(false);
            playerController!.setVolume(2);
          });
  }

  @override
  void dispose() {
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: VideoPlayer(playerController!),
    );
  }
}
