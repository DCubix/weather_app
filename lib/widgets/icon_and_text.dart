import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  const IconAndText({
    super.key,
    required this.icon,
    required this.text,
    this.color = Colors.black87,
  });

  final Widget icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconTheme(
          data: IconThemeData(color: color),
          child: icon,
        ),
        const SizedBox(width: 4.0),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
