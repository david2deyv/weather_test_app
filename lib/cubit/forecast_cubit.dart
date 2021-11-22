import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_test_app/api/weather_api.dart';
import 'package:weather_test_app/api/weather_repository.dart';
import 'package:weather_test_app/api/weather_target.dart';
import 'package:weather_test_app/models/weather_forecast_daily_one.dart';
import 'package:weather_test_app/utilites/location.dart';

part 'forecast_state.dart';

class ForecastCubit extends Cubit<ForecastState> {
  final WeatherRepository _repository;
  WeatherTarget _target = WeatherTargetCity('London');
  WeatherTarget _newTarget = WeatherTargetCity('jghgjh');

  ForecastCubit(this._repository) : super(LoadingState());

  Future<void> changeCityEvent(String city) async {
    if (city != '') {
      _newTarget = WeatherTargetCity(city);
      loadWeather();
    } else {
      emit(WrongCityState(message: 'It is impossible to identify the city'));
      firstLoadWeather();
    }
  }

  Future<void> loadWeatherByLocation() async {
    emit(LoadingState());
    try {
      Location location = Location();
      await location.getCurrentLocation();

      _newTarget = WeatherTargetLocation(location);
      loadWeather();
    } catch (e) {
      emit(ErrorState(message: 'It is impossible to determine the location'));
      firstLoadWeather();
    }
  }

  Future<void> loadWeather() async {
    emit(LoadingState());
    try {
      final WeatherForecast forecast =
      await _repository.getWeatherApi(target: _newTarget);
      emit(LoadedState(forecast));
      _target = _newTarget;
    } on WrongCityException catch (_) {
      emit(WrongCityState(message: 'No city detected'));
      firstLoadWeather();
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  Future<void> firstLoadWeather() async {
    emit(LoadingState());
    try {
      final WeatherForecast forecast =
      await _repository.getWeatherApi(target: _target);
      emit(LoadedState(forecast));
    } on WrongCityException catch (_) {
      emit(WrongCityState(message: 'No city detected'));
    } on SocketException catch (e) {
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}



