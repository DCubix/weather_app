import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:language_code/language_code.dart';
import 'package:unicons/unicons.dart';
import 'package:weather_app/globals.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/widgets/icon_and_text.dart';
import 'package:weather_app/widgets/transparent_card.dart';

class ForecastCard extends StatelessWidget {
  const ForecastCard({super.key, required this.data, required this.isDay});

  final Forecast data;
  final bool isDay;

  @override
  Widget build(BuildContext context) {
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    final fmtDecimal = NumberFormat.decimalPatternDigits(decimalDigits: 0, locale: LanguageCode.code.code);
    final fmtWeekDay = DateFormat.E(tag);
    final fmtDayMo = DateFormat.Md(tag);
    final now = DateTime.now();
    
    var weekDay = fmtWeekDay.format(data.date);
    if (data.date.day == now.day) {
      weekDay = 'Today';
    } else if (data.date.day == now.day + 1) {
      weekDay = 'Tomorrow';
    }

    return TransparentCard(
      isDay: isDay,
      padding: 12.0,
      child: Row(
        children: [
          Image.asset(
            'assets/weather/${data.weatherIcon}',
            width: 26.0,
            color: cardIconColor(isDay),
            alignment: Alignment.center,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _smallStackedText(weekDay, fmtDayMo.format(data.date)),
          ),
      
          // min and max temps
          IconAndText(
            icon: const Icon(UniconsLine.arrow_down),
            text: '${fmtDecimal.format(data.minTemperture)}°',
            color: cardIconColor(isDay),
          ),
          const SizedBox(width: 6),
          IconAndText(
            icon: const Icon(UniconsLine.arrow_up),
            text: '${fmtDecimal.format(data.maxTemperture)}°',
            color: cardIconColor(isDay),
          ),
        ]
      ),
    );
  }

  Widget _smallStackedText(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: cardTextColor(isDay),
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: cardIconColor(isDay).withOpacity(0.7),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
