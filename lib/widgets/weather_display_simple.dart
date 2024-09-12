import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:language_code/language_code.dart';
import 'package:weather_app/globals.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/widgets/icon_and_text.dart';

class WeatherDisplaySimple extends StatelessWidget {
  const WeatherDisplaySimple({
    super.key,
    required this.data,
  });

  final Weather data;

  @override
  Widget build(BuildContext context) {
    final fmtDecimal = NumberFormat.decimalPatternDigits(decimalDigits: 0, locale: LanguageCode.code.code);
    const whiteText = TextStyle(fontSize: 14, color: Colors.white, height: 1);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${data.cityName}, ${data.countryCode}',
              style: whiteText,
            ),
            Text(
              '${fmtDecimal.format(data.temperature)}°',
              style: whiteText.copyWith(fontSize: 38.0),
            ),
          ],
        ),
        const Spacer(),
        IconAndText(
          icon: Image.asset(
            'assets/weather/${data.weatherIcon}',
            width: 32.0,
            color: cardIconColor(data.isDay),
            alignment: Alignment.center,
          ),
          text: data.weatherDescription,
          color: cardTextColor(data.isDay),
        ),
      ],
    );
  }
}
