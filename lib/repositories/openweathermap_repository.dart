import 'dart:convert';

import 'package:language_code/language_code.dart';
import 'package:weather_app/models/payload.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repositories/weather_repository_base.dart';

final _iconTranslationTable = {
  '01d': 'fair_day.png',
  '01n': 'fair_night.png',
  '02d': 'partlycloudy_day.png',
  '02n': 'partlycloudy_night.png',
  '03d': 'cloudy.png',
  '03n': 'cloudy.png',
  '04d': 'overcast.png',
  '04n': 'overcast.png',
  '09d': 'lightrainshowers_day.png',
  '09n': 'lightrainshowers_night.png',
  '10d': 'rainshowers_day.png',
  '10n': 'rainshowers_night.png',
  '11d': 'thunderstorms_day.png',
  '11n': 'thunderstorms_night.png',
  '13d': 'snowshowers_day.png',
  '13n': 'snowshowers_night.png',
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

    final data = raw.data!['current'];

    return Payload.success(Weather(
      timeZone: raw.data!['timezone'],
      cityName: raw.data!['name'],
      countryCode: raw.data!['sys']['country'],
      windSpeed: data['wind_speed'],
      windDirection: data['wind_deg'],
      windDirectionCardinal: '',
      temperature: data['temp'],
      feelsLike: data['feels_like'],
      relativeHumidity: data['humidity'],
      isDay: data['dt'] < data['sunset'],
      weatherIcon: _iconTranslationTable[data['weather'][0]['icon']] ?? 'fair_day.png',
      weatherDescription: data['weather'][0]['description'],
      precipitation: data['rain'] != null ? data['rain']['1h'] : 0,
      aqi: 0,
      pressure: data['pressure'],
    ));
  }

  @override
  String get keyParameter => 'appid';
  
  @override
  String parseError(String body) {
    return json.decode(body)['message'] ?? 'Unknown error';
  }

}
