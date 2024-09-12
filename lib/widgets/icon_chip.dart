import 'package:flutter/material.dart';

class IconChip extends StatelessWidget {
  const IconChip({
    super.key,
    required this.icon,
    required this.text,
  });

  final Widget icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    const whiteText = TextStyle(fontSize: 18, color: Colors.white, height: 1);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(50, 255, 255, 255),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconTheme(
            data: const IconThemeData(size: 24.0, color: Color.fromARGB(200, 255, 255, 255)),
            child: icon,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: whiteText.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
