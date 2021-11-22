import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_test_app/api/weather_api.dart';
import 'package:weather_test_app/api/weather_target.dart';
import 'package:weather_test_app/models/weather_forecast_daily_one.dart';

abstract class WeatherRepository {
  Future<WeatherForecast> getWeatherApi({WeatherTarget target});

  Future<WeatherForecast> getLastCachedResult();
}

class WeatherRepositoryImpl implements WeatherRepository {
  static const String _storageKey = 'last_weather_forecast';
  WeatherApi _weatherApi = WeatherApi();

  Future<WeatherForecast> getWeatherApi({WeatherTarget? target}) async {
    final prefs = await SharedPreferences.getInstance();
    final WeatherForecast result;
    if (target is WeatherTargetCity) {
      result = await _weatherApi.fetchWeatherForecastByCity(
          cityName: target.cityName);
    } else if (target is WeatherTargetLocation) {
      result = await _weatherApi.fetchWeatherForecastByLocation(
          location: target.location);
    } else {
      return Future.error('Unknown target');
    }

    prefs.setString(_storageKey, jsonEncode(result));
    return result;
  }

  @override
  Future<WeatherForecast> getLastCachedResult() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_storageKey);
    if (json == null) return Future.error('No result');

    return WeatherForecast.fromJson(jsonDecode(json));
  }
}

class WeatherRepositoryMock implements WeatherRepository {
  @override
  Future<WeatherForecast> getWeatherApi({WeatherTarget? target}) async {
    return WeatherForecast(city: City(name: 'Kiev', country: 'UA'));
  }

  @override
  Future<WeatherForecast> getLastCachedResult() async {
    return WeatherForecast(city: City(name: 'Kiev', country: 'UA'));
  }
}
