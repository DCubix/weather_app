import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  const IconAndText({
    super.key,
    required this.icon,
    required this.text,
    this.color = Colors.black87,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
