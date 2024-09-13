import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/weather_summary.dart';
import 'package:weather_app/models/weather_units.dart';

import '../models/payload.dart';

abstract class WeatherRepositoryBase {

  final String apiKey;
  final String baseUrl;

  WeatherRepositoryBase({required this.baseUrl, required this.apiKey});

  Future<Payload<Map<String, dynamic>>> fetchRawData(String path, Map<String, dynamic> parameters) async {
    final fullUrl = '$baseUrl/$path';

    parameters[keyParameter] = apiKey;
    final res = await http.get(Uri.parse(fullUrl).replace(queryParameters: parameters));
    if (res.statusCode ~/ 100 == 2) {
      return Payload.success(json.decode(res.body));
    }
    return Payload.error(parseError(res.body));
  }

  String parseError(String body);
  Future<Payload<WeatherSummary>> fetchCurrentWeather(double latitude, double longitude, WeatherUnits unit);
  Future<Payload<List<Forecast>>> fetchWeatherForecast(double latitude, double longitude, WeatherUnits unit);

  // to specify the API key field name
  String get keyParameter;

}
