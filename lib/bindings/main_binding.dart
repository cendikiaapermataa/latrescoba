import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/character_controller.dart';
import '../controllers/spell_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => CharacterController());
    Get.lazyPut(() => SpellController());
  }
}