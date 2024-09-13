import 'package:flutter/material.dart';
import 'package:weather_app/globals.dart';

class TransparentCard extends StatelessWidget {
  const TransparentCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = 16,
    this.isDay = true,
  });

  final Widget child;
  final double borderRadius;
  final double padding;
  final bool isDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor(isDay),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}
