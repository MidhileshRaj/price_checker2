import 'package:get/get.dart';
import 'package:price_checker/routes/bindings.dart';
import 'package:price_checker/screens/configuration_screen.dart';

import '../screens/get_item_details.dart';
import 'app_routes.dart';


class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const ConfigurationScreen(),
      binding: MyAppBindings(),
    ), GetPage(
      name: Routes.main,
      page: () => const GetItemDetails(),
      binding: MyAppBindings(),
    ),
  ];
}
