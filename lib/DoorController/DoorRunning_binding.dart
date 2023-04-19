// ignore_for_file: file_names

import 'package:door/DoorController/DoorRunning_controller.dart';
import 'package:get/instance_manager.dart';

class DoorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DoorController(), permanent: true);
  }
}
