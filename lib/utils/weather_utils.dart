class WeatherUtils {
  static String kelvinToCelcius(double kelvin) {
    return (kelvin - 273.15).round().toString();
  }

  static String getWeatherIcon(double kelvin) {
    if (kelvin < 300) {
      return '☁';
    } else if (kelvin < 400) {
      return '🌧';
    } else if (kelvin < 600) {
      return '☔️';
    } else if (kelvin < 700) {
      return '☃️';
    } else if (kelvin < 800) {
      return '🌫';
    } else if (kelvin == 800) {
      return '☀️';
    } else if (kelvin <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  static String getDescription(int kelvin) {
    if (kelvin > 25) {
      return 'It\'s 🍦 time';
    } else if (kelvin > 20) {
      return 'Time for shorts and 👕';
    } else if (kelvin < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
