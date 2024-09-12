import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/repositories/openweathermap_repository.dart';
import 'package:weather_app/repositories/weather_repository_base.dart';
import 'package:weather_app/repositories/wheaterbit_repository.dart';
import 'package:location/location.dart';

final availableServices = ['Weatherbit', 'OpenWeatherMap'];

final weatherRepositoryProvider = Provider<WeatherRepositoryBase>((ref) {
  final key = ref.watch(selectedServicePrefProvider);
  switch (key) {
    case 'Weatherbit': return WeatherbitRepository();
    case 'OpenWeatherMap': return OpenWeatherMapRepository();
    default: throw 'Unknown service: $key';
  }
});

final currentLocationProvider = FutureProvider<LocationData>((ref) async {
  final loc = Location();
  var enabled = await loc.serviceEnabled();
  if (!enabled) {
    enabled = await loc.requestService();
    if (!enabled) {
      throw 'Location service is disabled';
    }
  }

  var permission = await loc.hasPermission();
  if (permission == PermissionStatus.denied) {
    permission = await loc.requestPermission();
    if (permission != PermissionStatus.granted) {
      throw 'Location permission was denied';
    }
  }

  return loc.getLocation();
});

final currentWeatherProvider = FutureProvider.autoDispose<Weather>((ref) async {
  // refresh every 30 minutes
  final timer = Timer(const Duration(minutes: 30), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  final repo = ref.watch(weatherRepositoryProvider);
  final unit = ref.watch(selectedUnitProvider);

  final location = await ref.watch(currentLocationProvider.future);

  final res = await repo.fetchCurrentWeather(location.latitude!, location.longitude!, unit);
  if (res.isError) {
    throw res.error!;
  }

  return res.data!;
});
