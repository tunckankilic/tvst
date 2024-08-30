import 'package:get/get.dart';
import 'package:tvst/view/auth/authentication_controller.dart';

class AuthenticationBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AuthenticationController());
  }
}
