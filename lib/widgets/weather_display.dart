import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:language_code/language_code.dart';
import 'package:unicons/unicons.dart';
import 'package:weather_app/globals.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_units.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';
import 'package:weather_app/widgets/basic_responsive.dart';
import 'package:weather_app/widgets/info_chip.dart';
import 'package:weather_app/widgets/info_card.dart';

List<PopupMenuEntry<String>> buildWeatherProviderMenu(WidgetRef ref) {
  return availableServices.map((service) {
    return PopupMenuItem(
      value: service,
      child: Text(service),
      onTap: () => ref.read(selectedServicePrefProvider.notifier).update(service),
    );
  }).toList();
}

class WeatherDisplay extends HookConsumerWidget {
  const WeatherDisplay({
    super.key,
    required this.data,
  });

  final Weather data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmtDecimal = NumberFormat.decimalPatternDigits(decimalDigits: 0, locale: LanguageCode.code.code);
    const whiteText = TextStyle(fontSize: 18, color: Colors.white, height: 1);

    final unit = ref.watch(selectedUnitProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 48.0),

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
              style: whiteText.copyWith(fontSize: 92),
            ),
          ],
        ),
    
        // description
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoChip(
              icon: Image.asset(
                'assets/weather/${data.weatherIcon}',
                width: 24.0,
                color: cardIconColor(data.isDay),
                alignment: Alignment.center,
              ),
              text: data.weatherDescription,
              isDay: data.isDay,
            ),
    
            const SizedBox(width: 6),
            
            // AQI
            InfoChip(
              icon: const Icon(UniconsLine.trees),
              text: 'AQI ${fmtDecimal.format(data.aqi)}',
              isDay: data.isDay,
            ),
          ],
        ),
    
        const SizedBox(height: 10),
    
        BasicResponsive(
          mobile: _buildInfoGrid(data, unit, 2),
          desktop: _buildInfoGrid(data, unit, 3),
          desktopHQ: _buildInfoGrid(data, unit, 3),
        ),

        const SizedBox(height: 64.0),
      ],
    );
  }

  Widget _buildInfoGrid(Weather data, WeatherUnits unit, int columns) {
    final fmtDecimal = NumberFormat.decimalPatternDigits(decimalDigits: 1, locale: LanguageCode.code.code);
    final fmtInt = NumberFormat.decimalPatternDigits(decimalDigits: 0, locale: LanguageCode.code.code);

    return StaggeredGrid.count(
      crossAxisCount: columns,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: InfoCard(
            titleText: 'Feels Like',
            valueText: '${fmtDecimal.format(data.feelsLike)} ${unit.temperatureSymbol}',
            icon: const Icon(UniconsLine.sun),
            isDay: data.isDay,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: InfoCard(
            titleText: 'Humidity (R.H.)',
            valueText: '${fmtInt.format(data.relativeHumidity)}%',
            icon: const Icon(Icons.water_drop_outlined),
            isDay: data.isDay,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: InfoCard(
            titleText: 'Wind Speed',
            valueText: '${fmtDecimal.format(unit.convertSpeed(data.windSpeed))} ${unit.speedSymbol}',
            icon: const Icon(UniconsLine.wind),
            isDay: data.isDay,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: InfoCard(
            titleText: 'Wind Direction',
            valueText: '${fmtInt.format(data.windDirection)}° ${data.windDirectionCardinal}',
            icon: Container(
              decoration: BoxDecoration(
                color: cardIconColor(data.isDay).withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Transform.rotate(
                angle: _windDirectionFromDegToRad(data.windDirection),
                child: const Icon(UniconsLine.arrow_right),
              ),
            ),
            isDay: data.isDay,
          ),
        ),

        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: InfoCard(
            titleText: 'Precipitation',
            valueText: '${fmtDecimal.format(data.precipitation)} ${unit.precipitationSymbol}',
            icon: const Icon(UniconsLine.raindrops),
            isDay: data.isDay,
          ),
        ),

        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: InfoCard(
            titleText: 'Pressure',
            valueText: '${fmtDecimal.format(data.pressure / 1013.0)} atm',
            icon: const Icon(UniconsLine.arrow_circle_down),
            isDay: data.isDay,
          ),
        ),
      ],
    );
  }

  double _windDirectionFromDegToRad(double deg) {
    return (deg - 90) * pi / 180;
  }

}
