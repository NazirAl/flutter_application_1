import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/utils/weather_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/utils/weather_utils.dart';

import 'city_page.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({
    Key key,
  }) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _celcius = '';
  String _icons;
  String _description = '';
  String _cityName = '';
  bool _isLoading = false;
  @override
  void initState() {
    _showWeatherByLocation();

    super.initState();
  }

  Future<void> _showWeatherByLocation() async {
    setState(() {
      _isLoading = true;
    });
    final position = await _getCurrentLocation();
    await getWetherByLocation(position: position);
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getWetherByLocation({@required Position position}) async {
    final client = http.Client();
    try {
      setState(() {
        _isLoading = true;
      });
      Uri uri = Uri.parse(
          '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=4049636d685428fb4e46690d31db5af2');
      final response = await client.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        final _data = jsonDecode(body) as Map<String, dynamic>;

        final kelvin = _data['main']['temp'] as num;

        _cityName = _data['name'];
        _celcius = WeatherUtils.kelvinToCelcius(kelvin).toString();
        _description = WeatherUtils.getDescription(int.parse(_celcius));
        _icons = WeatherUtils.getWeatherIcon(kelvin);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      throw Exception(e);
    }
  }

  Future<void> _getWeatherByCityName(String typedCityName) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final client = http.Client();

      Uri uri = Uri.parse('$baseUrl?q=$typedCityName&appid=$ApiKey');
      final response = await client.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        log('body ===> $body');
        // Worked untill this
        final _data = jsonDecode(body) as Map<String, dynamic>;
        final kelvin = _data['main']['temp'] as num;
        _cityName = _data['name'];

        _celcius = WeatherUtils.kelvinToCelcius(kelvin);
        _icons = WeatherUtils.getWeatherIcon(kelvin);
        _description = WeatherUtils.getDescription(int.parse(_celcius));
        setState(() {
          _isLoading = false;
        });
      }
    } catch (katany) {
      setState(() {
        _isLoading = false;
      });
      throw Exception(katany);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: null,
          icon: const Icon(
            Icons.navigation,
            size: 60.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: IconButton(
              onPressed: () async {
                setState(() {});
                final _typedCity = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => CityPage()),
                  ),
                );

                log('typedCity -===> $_typedCity');
                await _getWeatherByCityName(_typedCity).toString();
              },
              icon: const Icon(
                Icons.location_city,
                size: 60.0,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator(
                backgroundColor: Colors.blue,
                color: Colors.teal,
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/rainy.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _celcius.isEmpty
                          ? '$_celcius \u00B0 🌦'
                          : '$_celcius  \u00B0 $_icons',
                      style: TextStyle(
                        fontSize: 100.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _cityName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      _description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 60.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
