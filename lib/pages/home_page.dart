import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';
import 'package:weather_app/widgets/basic_responsive.dart';
import 'package:weather_app/widgets/percent_sized_box.dart';
import 'package:weather_app/widgets/weather_display.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currWeather = ref.watch(currentWeatherProvider);

    final colorsDay = [
      theme.primaryColor,
      const Color.fromARGB(255, 122, 197, 255),
    ];
    final colorsNight = [
      const Color.fromARGB(255, 2, 22, 44),
      const Color.fromARGB(255, 9, 62, 110),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      backgroundColor: theme.primaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          currWeather.maybeWhen(
            orElse: () => const SizedBox(),
            data: (data) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: data.isDay ? colorsDay : colorsNight,
                  stops: const [0.8, 1.0],
                ),
              ),
            ),
          ),

          currWeather.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
            error: (ex, _) {
              final err = ex is Exception ? ex.toString() : 'Unknown error';
              return Center(
                child: BasicResponsive(
                  mobile: _buildError(err, 1.0),
                  tablet: _buildError(err, 0.9),
                  desktop: _buildError(err, 0.6),
                  desktopHQ: _buildError(err, 0.3),
                ),
              );
            },
            data: (data) => SingleChildScrollView(
              child: BasicResponsive(
                mobile: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 48.0),
                  child: _buildWeatherDisplay(data, 1.0),
                ),
                tablet: _buildWeatherDisplay(data, 0.9),
                desktop: _buildWeatherDisplay(data, 0.6),
                desktopHQ: _buildWeatherDisplay(data, 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error, double widthFactor) {
    return PercentSizedBox(
      widthFactor: widthFactor,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(UniconsLine.exclamation_triangle, color: Colors.black87),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                error,
                style: const TextStyle(color: Colors.black87, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDisplay(Weather data, double widthFactor) {
    return PercentSizedBox(
      widthFactor: widthFactor,
      child: WeatherDisplay(data: data),
    );
  }
}
