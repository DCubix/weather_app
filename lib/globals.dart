import 'package:flutter/material.dart';

const cardDay = Color.fromARGB(220, 255, 255, 255);
const cardNight = Color.fromARGB(40, 255, 255, 255);
final cardTextDay = Colors.black.withOpacity(0.7);
const cardTextNight = Colors.white70;
final cardIconDay = Colors.black.withOpacity(0.75);
const cardIconNight = Colors.white;

Color cardColor(bool isDay) => isDay ? cardDay : cardNight;
Color cardTextColor(bool isDay) => isDay ? cardTextDay : cardTextNight;
Color cardIconColor(bool isDay) => isDay ? cardIconDay : cardIconNight;

final inputStyleWhite = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  isDense: true,
  labelStyle: const TextStyle(color: Colors.black87),
);
