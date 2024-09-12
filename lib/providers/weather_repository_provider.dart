import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences_riverpod/shared_preferences_riverpod.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/repositories/openweathermap_repository.dart';
import 'package:weather_app/repositories/weather_repository_base.dart';
import 'package:weather_app/repositories/wheaterbit_repository.dart';
import 'package:location/location.dart';

final availableServices = ['Weatherbit', 'OpenWeatherMap'];

final selectedServicePrefProvider = createPrefProvider<String>(
  prefs: (_) => globalPrefs,
  prefKey: 'weather_service_key',
  defaultValue: 'Weatherbit',
);

final weatherRepositoryProvider = Provider<WeatherRepositoryBase>((ref) {
  final key = ref.watch(selectedServicePrefProvider);
  switch (key) {
    case 'Weatherbit': return WeatherbitRepository();
    case 'OpenWeatherMap': return OpenWeatherMapRepository();
    default: throw UnimplementedError('Unknown service: $key');
  }
});

final currentLocationProvider = FutureProvider<LocationData>((ref) async {
  final loc = Location();
  var enabled = await loc.serviceEnabled();
  if (!enabled) {
    enabled = await loc.requestService();
    if (!enabled) {
      throw Exception('Location service is disabled');
    }
  }

  var permission = await loc.hasPermission();
  if (permission == PermissionStatus.denied) {
    permission = await loc.requestPermission();
    if (permission != PermissionStatus.granted) {
      throw Exception('Location permission was denied');
    }
  }

  return loc.getLocation();
});

final currentWeatherProvider = FutureProvider<Weather>((ref) async {
  final repo = ref.watch(weatherRepositoryProvider);
  final unit = ref.watch(selectedUnitProvider);

  final location = await ref.watch(currentLocationProvider.future);

  final res = await repo.fetchCurrentWeather(location.latitude!, location.longitude!, unit);
  if (res.isError) {
    throw Exception(res.error);
  }

  return res.data!;
});
