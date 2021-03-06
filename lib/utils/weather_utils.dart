class WeatherUtils {
  static String kelvinToCelcius(double kelvin) {
    return (kelvin - 273.15).round().toString();
  }

  static String getWeatherIcon(double kelvin) {
    if (kelvin < 300) {
      return 'โ';
    } else if (kelvin < 400) {
      return '๐ง';
    } else if (kelvin < 600) {
      return 'โ๏ธ';
    } else if (kelvin < 700) {
      return 'โ๏ธ';
    } else if (kelvin < 800) {
      return '๐ซ';
    } else if (kelvin == 800) {
      return 'โ๏ธ';
    } else if (kelvin <= 804) {
      return 'โ๏ธ';
    } else {
      return '๐คทโ';
    }
  }

  static String getDescription(int kelvin) {
    if (kelvin > 25) {
      return 'It\'s ๐ฆ time';
    } else if (kelvin > 20) {
      return 'Time for shorts and ๐';
    } else if (kelvin < 10) {
      return 'You\'ll need ๐งฃ and ๐งค';
    } else {
      return 'Bring a ๐งฅ just in case';
    }
  }
}
