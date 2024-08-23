import 'package:get/get.dart';
import 'package:tvst/authentication/authentication_controller.dart';

class AuthenticationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationController());
  }
}
