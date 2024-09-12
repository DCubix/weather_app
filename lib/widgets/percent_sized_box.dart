import 'package:flutter/material.dart';

class PercentSizedBox extends StatelessWidget {
  const PercentSizedBox({super.key, required this.child, this.widthFactor, this.heightFactor});

  final Widget child;
  final double? widthFactor, heightFactor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = widthFactor != null ? size.width * widthFactor! : null;
    final height = heightFactor != null ? size.height * heightFactor! : null;
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}
