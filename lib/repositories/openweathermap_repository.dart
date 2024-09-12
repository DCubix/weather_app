import 'dart:convert';

import 'package:language_code/language_code.dart';
import 'package:weather_app/models/payload.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_units.dart';
import 'package:weather_app/repositories/weather_repository_base.dart';

import 'package:http/http.dart' as http;

final _iconTranslationTable = {
  '01d': 'clearsky_day.png',
  '01n': 'clearsky_night.png',
  '02d': 'fair_day.png',
  '02n': 'fair_night.png',
  '03d': 'cloudy.png',
  '03n': 'cloudy.png',
  '04d': 'cloudy.png',
  '04n': 'cloudy.png',
  '09d': 'lightrainshowers_day.png',
  '09n': 'lightrainshowers_night.png',
  '10d': 'rainshowers_day.png',
  '10n': 'rainshowers_night.png',
  '11d': 'rainshowersandthunder_day.png',
  '11n': 'rainshowersandthunder_night.png',
  '13d': 'snow.png',
  '13n': 'snow.png',
  '50d': 'fog.png',
  '50n': 'fog.png'
};

class OpenWeatherMapRepository extends WeatherRepositoryBase {
  OpenWeatherMapRepository() : super(baseUrl: 'https://api.openweathermap.org/data/3.0', apiKey: '075bbecd32fb6bb8bc751d647c381431');

  @override
  Future<Payload<Weather>> fetchCurrentWeather(double latitude, double longitude, WeatherUnits unit) async {
    final raw = await fetchRawData('onecall', {
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'exclude': 'minutely,hourly,daily,alerts',
      'units': unit == WeatherUnits.metric ? 'metric' : 'imperial',
      'lang': LanguageCode.code.code.toLowerCase(),
    });

    if (raw.isError) {
      return Payload.error(raw.error!);
    }

    // use reverse geocoding to get city name and country code
    final cityPayload = await _fetchCity(latitude, longitude);
    if (cityPayload.isError) {
      return Payload.error(cityPayload.error!);
    }

    // fetch air quality index
    final aqiPayload = await _fetchAQI(latitude, longitude);
    if (aqiPayload.isError) {
      return Payload.error(aqiPayload.error!);
    }

    final city = cityPayload.data!;
    final data = raw.data!['current'];
    final aqi = aqiPayload.data!;

    return Payload.success(Weather(
      timeZone: raw.data!['timezone'],
      cityName: city['name']!,
      countryCode: city['country']!,
      windSpeed: data['wind_speed'],
      windDirection: data['wind_deg'],
      windDirectionCardinal: _angleToCardinalWind(data['wind_deg']),
      temperature: data['temp'],
      feelsLike: data['feels_like'],
      relativeHumidity: data['humidity'],
      isDay: data['dt'] < data['sunset'],
      weatherIcon: _iconTranslationTable[data['weather'][0]['icon']] ?? 'fair_day.png',
      weatherDescription: data['weather'][0]['description'],
      precipitation: data['rain'] != null ? data['rain']['1h'] : 0,
      aqi: aqi,
      pressure: data['pressure'],
    ));
  }

  @override
  String get keyParameter => 'appid';
  
  @override
  String parseError(String body) {
    return json.decode(body)['message'] ?? 'Unknown error';
  }

  Future<Payload<Map<String, String>>> _fetchCity(double lat, double lon) async {
    final url = 'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$apiKey';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode ~/ 100 == 2) {
      final data = json.decode(res.body)[0];
      final localNames = data['local_names']! as Map<String, dynamic>;

      var cityName = data['name']! as String;
      final lang = LanguageCode.locale.languageCode.toLowerCase();
      if (localNames.containsKey(lang)) {
        cityName = localNames[lang]!;
      }

      return Payload.success({
        'name': cityName,
        'country': data['country']!
      });
    }
    return Payload.error(parseError(res.body));
  }

  Future<Payload<double>> _fetchAQI(double lat, double lon) async {
    final url = 'http://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode ~/ 100 == 2) {
      return Payload.success(json.decode(res.body)['list'][0]['main']['aqi']);
    }
    return Payload.error(parseError(res.body));
  }

  String _angleToCardinalWind(double deg) {
    const compass = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
    final index = ((deg % 360) / 22.5).round();
    return compass[index % 16];
  }

}
