import 'package:shared_preferences_riverpod/shared_preferences_riverpod.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/repositories/weather_repository_base.dart';

final selectedUnitProvider = createPrefProvider<WeatherUnits>(
  prefs: (_) => globalPrefs,
  prefKey: 'unit_key',
  defaultValue: WeatherUnits.metric,
);


