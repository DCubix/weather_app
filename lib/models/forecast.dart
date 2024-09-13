class Forecast {
  final DateTime date;

  final double minTemperture;
  final double maxTemperture;
  final double relativeHumidity;
  final double precipitation;

  final double windSpeed; // m/s
  final double windDirection; // degrees
  final String windDirectionCardinal; // N, NE, E, SE, S, SW, W, NW

  final String weatherIcon;
  final String weatherDescription;

  Forecast({
    required this.date,
    required this.minTemperture,
    required this.maxTemperture,
    required this.relativeHumidity,
    required this.precipitation,
    required this.windSpeed,
    required this.windDirection,
    required this.windDirectionCardinal,
    required this.weatherIcon,
    required this.weatherDescription,
  });
}
