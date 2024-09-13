class WeatherSummary {
  final String cityName;
  final String countryCode;

  final double windSpeed; // m/s
  final double windDirection; // degrees
  final String windDirectionCardinal; // N, NE, E, SE, S, SW, W, NW

  final double temperature;
  final double feelsLike;
  final double relativeHumidity; // %
  final double pressure; // mb

  final bool isDay;

  final String weatherIcon;
  final String weatherDescription;

  final double precipitation; // mm/h
  final double aqi; // Air Quality Index [US - EPA standard 0 - 500]

  WeatherSummary({
    required this.cityName,
    required this.countryCode,
    required this.windSpeed,
    required this.windDirection,
    required this.windDirectionCardinal,
    required this.temperature,
    required this.feelsLike,
    required this.relativeHumidity,
    required this.isDay,
    required this.weatherIcon,
    required this.weatherDescription,
    required this.precipitation,
    required this.aqi,
    required this.pressure,
  });
}
