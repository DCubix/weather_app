import 'package:shared_preferences_riverpod/shared_preferences_riverpod.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/weather_units.dart';

final selectedUnitProvider = createPrefProvider<WeatherUnits>(
  prefs: (_) => globalPrefs,
  prefKey: 'unit_key',
  defaultValue: WeatherUnits.metric,
);

final selectedServicePrefProvider = createPrefProvider<String>(
  prefs: (_) => globalPrefs,
  prefKey: 'weather_service_key',
  defaultValue: 'Weatherbit',
);
