import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/screens/add_slider_images.dart';
import 'package:price_checker/utils/constants/colors.dart';

import '../configuration_screen.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key, this.onTapAdConfig, this.onTapConfig});

 final VoidCallback? onTapAdConfig;
 final VoidCallback? onTapConfig;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: MyAppColors.primary
              ),
              child: Text(
                'Configurations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_done_sharp),
            title: const Text('Server Configurations.'),
            onTap: onTapConfig,
          ),
          ListTile(
            leading: const Icon(Icons.live_tv_rounded),
            title: const Text('Ad. settings'),
            onTap: onTapAdConfig,
          ),

        ],
      ),
    );
  }
}
