import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:language_code/language_code.dart';
import 'package:unicons/unicons.dart';
import 'package:weather_app/globals.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_summary.dart';
import 'package:weather_app/models/weather_units.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';
import 'package:weather_app/widgets/forecast_card.dart';
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
              '${data.current.cityName}, ${data.current.countryCode}',
              style: whiteText,
            ),
            Text(
              '${fmtDecimal.format(data.current.temperature)}°',
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
                'assets/weather/${data.current.weatherIcon}',
                width: 24.0,
                color: cardIconColor(data.current.isDay),
                alignment: Alignment.center,
              ),
              text: data.current.weatherDescription,
              isDay: data.current.isDay,
            ),
    
            const SizedBox(width: 6),
            
            // AQI
            InfoChip(
              icon: const Icon(UniconsLine.trees),
              text: 'AQI ${fmtDecimal.format(data.current.aqi)}',
              isDay: data.current.isDay,
            ),
          ],
        ),
    
        const SizedBox(height: 10),

        _buildCurrentWeather(data.current, unit),

        const SizedBox(height: 10),

        _buildForecast(data, unit),

        const SizedBox(height: 64.0),
      ],
    );
  }

  Widget _buildCurrentWeather(WeatherSummary data, WeatherUnits unit) {
    final fmtDecimal = NumberFormat.decimalPatternDigits(decimalDigits: 1, locale: LanguageCode.code.code);
    final fmtInt = NumberFormat.decimalPatternDigits(decimalDigits: 0, locale: LanguageCode.code.code);

    final gridItems = [
      InfoCard(
        titleText: 'Feels Like',
        valueText: '${fmtDecimal.format(data.feelsLike)} ${unit.temperatureSymbol}',
        icon: const Icon(UniconsLine.sun),
        isDay: data.isDay,
      ),
      InfoCard(
        titleText: 'Humidity (R.H.)',
        valueText: '${fmtInt.format(data.relativeHumidity)}%',
        icon: const Icon(Icons.water_drop_outlined),
        isDay: data.isDay,
      ),
      InfoCard(
        titleText: 'Wind Speed',
        valueText: '${fmtDecimal.format(unit.convertSpeed(data.windSpeed))} ${unit.speedSymbol}',
        icon: const Icon(UniconsLine.wind),
        isDay: data.isDay,
      ),
      InfoCard(
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
      InfoCard(
        titleText: 'Precipitation',
        valueText: '${fmtDecimal.format(data.precipitation)} ${unit.precipitationSymbol}',
        icon: const Icon(UniconsLine.raindrops),
        isDay: data.isDay,
      ),
      InfoCard(
        titleText: 'Pressure',
        valueText: '${fmtDecimal.format(data.pressure / 1013.0)} atm',
        icon: const Icon(UniconsLine.arrow_circle_down),
        isDay: data.isDay,
      ),
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: AnimationLimiter(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          shrinkWrap: true,
          itemCount: gridItems.length,
          itemBuilder: (_, index) => AnimationConfiguration.staggeredList(
            duration: const Duration(milliseconds: 500),
            position: index,
            child: SlideAnimation(
              horizontalOffset: -20.0,
              child: FadeInAnimation(child: gridItems[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForecast(Weather data, WeatherUnits unit) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weather Forecast',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w200,
              height: 2.5,
            ),
          ),

          AnimationLimiter(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1.0 / 0.2,
              ),
              shrinkWrap: true,
              itemCount: data.forecast.length,
              itemBuilder: (_, index) => AnimationConfiguration.staggeredList(
                duration: const Duration(milliseconds: 500),
                position: index,
                child: SlideAnimation(
                  horizontalOffset: -20.0,
                  child: FadeInAnimation(
                    child: ForecastCard(
                      data: data.forecast[index],
                      isDay: data.current.isDay,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _windDirectionFromDegToRad(double deg) {
    return (deg - 90) * pi / 180;
  }

}
