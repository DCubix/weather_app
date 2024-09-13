import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/repositories/openweathermap_repository.dart';
import 'package:weather_app/repositories/weather_repository_base.dart';
import 'package:weather_app/repositories/wheaterbit_repository.dart';

final availableServices = ['Weatherbit', 'OpenWeatherMap'];

final weatherRepositoryProvider = Provider<WeatherRepositoryBase>((ref) {
  final key = ref.watch(selectedServicePrefProvider);
  switch (key) {
    case 'Weatherbit': return WeatherbitRepository();
    case 'OpenWeatherMap': return OpenWeatherMapRepository();
    default: throw 'Unknown service: $key';
  }
});

final currentLocationProvider = FutureProvider<Position>((ref) async {
  var enabled = await Geolocator.isLocationServiceEnabled();
  if (!enabled) {
    throw 'Location service is disabled';
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permission was denied';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw 'Location permissions are permanently denied.';
  }

  return Geolocator.getCurrentPosition();
});

final currentWeatherProvider = FutureProvider.autoDispose<Weather>((ref) async {
  // refresh every 30 minutes
  final timer = Timer(const Duration(minutes: 30), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  final repo = ref.watch(weatherRepositoryProvider);
  final unit = ref.watch(selectedUnitProvider);

  final location = await ref.watch(currentLocationProvider.future);

  final currentRes = await repo.fetchCurrentWeather(location.latitude, location.longitude, unit);
  if (currentRes.isError) {
    throw currentRes.error!;
  }

  final forecastRes = await repo.fetchWeatherForecast(location.latitude, location.longitude, unit);
  if (forecastRes.isError) {
    throw forecastRes.error!;
  }
  
  return Weather(
    current: currentRes.data!,
    forecast: forecastRes.data!,
  );
});
