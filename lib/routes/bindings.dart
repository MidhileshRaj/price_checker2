import 'package:get/get.dart';
import 'package:price_checker/controller/configuration_controller.dart';
import 'package:price_checker/controller/main_controller.dart';

class MyAppBindings implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => ConfigurationController(),);
    Get.lazyPut(() => MainController(),);

  }
}