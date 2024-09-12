import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

import '../models/payload.dart';

enum WeatherUnits {
  metric,
  imperial;

  String get temperatureSymbol {
    switch (this) {
      case WeatherUnits.metric:
        return '°C';
      case WeatherUnits.imperial:
        return '°F';
    }
  }

  String get speedSymbol {
    switch (this) {
      case WeatherUnits.metric:
        return 'km/h';
      case WeatherUnits.imperial:
        return 'mph';
    }
  }

  String get precipitationSymbol {
    switch (this) {
      case WeatherUnits.metric:
        return 'mm';
      case WeatherUnits.imperial:
        return 'in';
    }
  }

  double convertSpeed(double mps) {
    switch (this) {
      case WeatherUnits.metric:
        return mps * 3.6;
      case WeatherUnits.imperial:
        return mps; // comes as mph
    }
  }
}

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
  Future<Payload<Weather>> fetchCurrentWeather(double latitude, double longitude, WeatherUnits unit);

  // to specify the API key field name
  String get keyParameter;

}
