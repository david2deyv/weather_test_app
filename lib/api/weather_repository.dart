import 'package:weather_test_app/api/weather_api.dart';
import 'package:weather_test_app/api/weather_target.dart';
import 'package:weather_test_app/models/weather_forecast_daily_one.dart';

abstract class WeatherRepository {
  Future<WeatherForecast> getWeatherApi({WeatherTarget target});
}

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherApi _weatherApi = WeatherApi();
  Future<WeatherForecast> getWeatherApi({WeatherTarget? target}) async {
    if (target is WeatherTargetCity) {
      return _weatherApi.fetchWeatherForecastByCity(cityName: target.cityName);
    } else if (target is WeatherTargetLocation) {
      return _weatherApi.fetchWeatherForecastByLocation(
          location: target.location);
    } else {
      return Future.error('Unknown target');
    }
  }
}

class WeatherRepositoryMock implements WeatherRepository {
  @override
  Future<WeatherForecast> getWeatherApi({WeatherTarget? target}) async {
    return WeatherForecast(city: City(name: 'Kiev', country: 'UA'));
  }
}