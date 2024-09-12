import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width < 500;
}

class BasicResponsive extends StatelessWidget {
  const BasicResponsive({
    super.key,
    required this.mobile,
    required this.desktop,
    required this.desktopHQ,
    this.tablet,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final Widget desktopHQ;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return switch (width) {
      < 500 => mobile,
      <= 800 => tablet ?? desktop,
      < 1281 => desktop,
      _ => desktopHQ
    };
  }
}
