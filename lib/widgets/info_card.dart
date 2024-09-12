import 'package:flutter/material.dart';
import 'package:weather_app/globals.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.titleText,
    required this.valueText,
    required this.isDay,
    this.icon,
  });

  final String titleText, valueText;
  final Widget? icon;

  final bool isDay;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 15,
      color: cardTextColor(isDay),
      height: 1
    );
    return Card(
      elevation: 0.0,
      color: isDay ? 
        const Color.fromARGB(220, 255, 255, 255) :
        const Color.fromARGB(40, 255, 255, 255),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(0.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(titleText, style: textStyle),
            ),
            const SizedBox(height: 5),
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                valueText,
                style: textStyle.copyWith(
                  fontSize: 22, color: cardIconColor(isDay),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            if (icon != null) FittedBox(
              alignment: Alignment.centerRight,
              fit: BoxFit.scaleDown,
              child: IconTheme(
                data: IconThemeData(
                  color: cardIconColor(isDay),
                  size: 46,
                ),
                child: icon!
              ),
            ),
          ],
        ),
      ),
    );
  }
}
