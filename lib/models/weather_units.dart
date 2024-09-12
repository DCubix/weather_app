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
        return mps * 3.6; // m/s to km/h
      case WeatherUnits.imperial:
        return mps; // comes as mph
    }
  }
}
