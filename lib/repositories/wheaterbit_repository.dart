import 'dart:convert';

import 'package:language_code/language_code.dart';
import 'package:weather_app/models/payload.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_units.dart';
import 'package:weather_app/repositories/weather_repository_base.dart';

final _iconTranslationTable = {
  't01d': 'lightrainandthunder.png',
  't01n': 'lightrainandthunder.png',
  't02d': 'rainandthunder.png',
  't02n': 'rainandthunder.png',
  't03d': 'heavyrainandthunder.png',
  't03n': 'heavyrainandthunder.png',
  't04d': 'lightrainandthunder.png',
  't04n': 'lightrainandthunder.png',
  't05d': 'heavyrainandthunder.png',
  't05n': 'heavyrainandthunder.png',
  'd01d': 'lightrain.png',
  'd01n': 'lightrain.png',
  'd02d': 'rain.png',
  'd02n': 'rain.png',
  'd03d': 'heavyrain.png',
  'd03n': 'heavyrain.png',
  'r01d': 'lightrainshowers_day.png',
  'r01n': 'lightrainshowers_night.png',
  'r02d': 'rainshowers_day.png',
  'r02n': 'rainshowers_night.png',
  'r03d': 'heavyrainshowers_day.png',
  'r03n': 'heavyrainshowers_night.png',
  'f01d': 'sleet.png',
  'f01n': 'sleet.png',
  's01d': 'lightsnowshowers_day.png',
  's01n': 'lightsnowshowers_night.png',
  's02d': 'snowshowers_day.png',
  's02n': 'snowshowers_night.png',
  's03d': 'heavysnowshowers_day.png',
  's03n': 'heavysnowshowers_night.png',
  's04d': 'lightsleetshowers_day.png',
  's04n': 'lightsleetshowers_night.png',
  's05d': 'heavysleetshowers_day.png',
  's05n': 'heavysleetshowers_night.png',
  's06d': 'lightsnowshowers_day.png',
  's06n': 'lightsnowshowers_night.png',
  'a01d': 'fog.png',
  'a01n': 'fog.png',
  'a02d': 'fog.png',
  'a02n': 'fog.png',
  'a03d': 'fog.png',
  'a03n': 'fog.png',
  'a04d': 'fog.png',
  'a04n': 'fog.png',
  'a05d': 'fog.png',
  'a05n': 'fog.png',
  'a06d': 'fog.png',
  'a06n': 'fog.png',
  'c01d': 'clearsky_day.png',
  'c01n': 'clearsky_night.png',
  'c02d': 'partlycloudy_day.png',
  'c02n': 'partlycloudy_night.png',
  'c03d': 'cloudy.png',
  'c03n': 'cloudy.png',
  'c04d': 'cloudy.png',
  'c04n': 'cloudy.png',
  'u00d': 'fog.png',
  'u00n': 'fog.png',
};

class WeatherbitRepository extends WeatherRepositoryBase {
  WeatherbitRepository() : super(baseUrl: 'http://api.weatherbit.io/v2.0', apiKey: 'ebe329c89098489ea5eade059de29782');
  
  @override
  String get keyParameter => 'key';

  @override
  Future<Payload<Weather>> fetchCurrentWeather(double latitude, double longitude, WeatherUnits unit) async {
    final unitConv = unit == WeatherUnits.metric ? 'M' : 'I';
    final raw = await fetchRawData('current', {
      'lang': LanguageCode.locale.languageCode,
      'units': unitConv,
      'lat': latitude.toString(),
      'lon': longitude.toString(),
    });

    if (raw.isError) {
      return Payload.error(raw.error!);
    }

    final data = raw.data!['data'][0];

    return Payload.success(Weather(
      timeZone: data['timezone'],
      cityName: data['city_name'],
      countryCode: data['country_code'],
      windSpeed: data['wind_spd'],
      windDirection: _toDouble(data['wind_dir']),
      windDirectionCardinal: data['wind_cdir'],
      temperature: data['temp'],
      feelsLike: data['app_temp'],
      relativeHumidity: _toDouble(data['rh']),
      isDay: data['pod'] == 'd',
      weatherIcon: _iconTranslationTable[data['weather']['icon']] ?? 'fair_day.png',
      weatherDescription: data['weather']['description'],
      precipitation: _toDouble(data['precip']),
      aqi: _toDouble(data['aqi']),
      pressure: _toDouble(data['pres']),
    ));
  }
  
  @override
  String parseError(String body) {
    return json.decode(body)['error'] ?? 'Unknown error';
  }

  double _toDouble(dynamic value) {
    return value is double ? value : value.toDouble();
  }
  
}
