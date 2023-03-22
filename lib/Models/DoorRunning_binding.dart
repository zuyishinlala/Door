import 'package:door/Models/DoorRunning_controller.dart';
import 'package:get/instance_manager.dart';

class DoorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoorController>(()=> DoorController());
  }
}
