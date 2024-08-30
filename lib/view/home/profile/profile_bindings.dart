import 'package:get/get.dart';
import 'package:tvst/view/home/profile/profile_controller.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => ProfileController());
  }
}
