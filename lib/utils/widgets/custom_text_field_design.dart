import 'package:flutter/material.dart';

class CustomTextFieldDesign extends StatelessWidget {
  const CustomTextFieldDesign(
      {super.key,
      required this.label,
      this.hint = "",
      required this.controller,
      this.obscure = false,
      this.enable = true,
      this.textInputType = TextInputType.text,
      this.validator});

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final bool enable;
  final TextInputType textInputType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * .5,
            child: TextFormField(
              enabled: enable,
              obscureText: obscure,
              obscuringCharacter: "*",
              keyboardType: textInputType,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 5),
                ),
              ),
              controller: controller,
              validator: validator,
            ),
          )
        ],
      ),
    );
  }
}
