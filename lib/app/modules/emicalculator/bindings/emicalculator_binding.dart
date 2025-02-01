import 'package:get/get.dart';

import '../controllers/emicalculator_controller.dart';

class EmicalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmicalculatorController>(
      () => EmicalculatorController(),
    );
  }
}
