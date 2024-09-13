import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 18.0, height: 18.0, child: CircularProgressIndicator(color: Colors.white));
  }
}
