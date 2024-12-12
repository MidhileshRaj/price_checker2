
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/string_constants.dart';

class OutPutWidget extends StatelessWidget {
  const OutPutWidget(
      {super.key,
        required this.productDetails,
        required this.productPrice,
        required this.productName,
        required this.backgroundImage,
        required this.height,
        required this.width});

  final String productDetails;
  final String productPrice;
  final String backgroundImage;
  final String productName;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (productDetails == StringConstants.noProduct) {
      return const Center(
        child: Text(
          StringConstants.alternativeResult,
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return

        /// Product details display
        Container(
          width: width * 0.7,
          height: height * 0.57,
          decoration: BoxDecoration(
            // Dark background color
              borderRadius: BorderRadius.circular(60),
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
                opacity: .9,
              )),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8ac43e).withOpacity(.6),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Text(
                  productName,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                    color: MyAppColors.secondary.withOpacity(.6),
                    borderRadius: BorderRadius.circular(45)),
                padding: const EdgeInsets.all(10),
                child: Text(
                  "AED $productPrice",
                ),
              ),
            ],
          ),
        );
    }
  }
}
