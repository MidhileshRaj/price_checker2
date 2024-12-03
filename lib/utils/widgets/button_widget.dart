
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onClicked;

  const ButtonWidget({
     this.text ="",
    required this.onClicked,
    super.key, this.icon,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onClicked,
    child: text==""?icon:Text(
      text,
      style: const TextStyle(fontSize: 24),
    ),
  );
}