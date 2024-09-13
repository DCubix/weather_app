import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/weather_summary.dart';

class Weather {
  final WeatherSummary current;
  final List<Forecast> forecast;

  Weather({required this.current, required this.forecast});
}
