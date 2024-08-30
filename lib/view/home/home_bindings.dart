import 'package:get/get.dart';
import 'package:tvst/view/home/following/controller_following_videos.dart';
import 'package:tvst/view/home/for_you/controller_for_you_videos.dart';
import 'package:tvst/view/home/profile/profile_controller.dart';
import 'package:tvst/view/home/search/search_controller.dart' as search;
import 'package:tvst/view/home/upload/upload_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerForYouVideos());
    Get.lazyPut(() => search.SearchController());
    Get.lazyPut(() => UploadController());
    Get.lazyPut(() => ControllerFollowingVideos());
    Get.lazyPut(() => ProfileController());
  }
}
