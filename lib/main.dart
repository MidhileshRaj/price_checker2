import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/routes/app_pages.dart';
import 'package:price_checker/routes/bindings.dart';
import 'package:price_checker/screens/configuration_screen.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialBinding: MyAppBindings(),
      home:ConfigurationScreen(),
    );
  }
}
