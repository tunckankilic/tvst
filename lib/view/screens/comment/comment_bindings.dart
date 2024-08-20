import 'package:get/get.dart';
import 'package:tvst/view/screens/comment/comment_controller.dart';

class CommentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommentController());
  }
}
