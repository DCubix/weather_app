import 'package:flutter/material.dart';
import 'package:weather_app/globals.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.icon,
    required this.text,
    required this.isDay,
  });

  final Widget icon;
  final String text;

  final bool isDay;

  @override
  Widget build(BuildContext context) {
    final textColor = cardTextColor(isDay);
    final textStyle = TextStyle(
      fontSize: 14,
      color: textColor,
      fontWeight: FontWeight.w600,
      height: 1
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: cardColor(isDay),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(size: 24.0, color: cardIconColor(isDay)),
            child: icon,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
