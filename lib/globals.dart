import 'package:flutter/material.dart';

const cardDay = Color.fromARGB(220, 255, 255, 255);
const cardNight = Color.fromARGB(40, 255, 255, 255);
const cardTextDay = Colors.black54;
const cardTextNight = Colors.white70;
final cardIconDay = Colors.black.withOpacity(0.75);
const cardIconNight = Colors.white;

Color cardColor(bool isDay) => isDay ? cardDay : cardNight;
Color cardTextColor(bool isDay) => isDay ? cardTextDay : cardTextNight;
Color cardIconColor(bool isDay) => isDay ? cardIconDay : cardIconNight;
