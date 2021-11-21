part of 'forecast_cubit.dart';

abstract class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object> get props => [];
}

class LoadingState extends ForecastState {}

class LoadedState extends ForecastState {
  final WeatherForecast forecast;

  LoadedState(this.forecast);
}

class WrongCityState extends ForecastState {
  final String message;

  WrongCityState({required this.message});

  @override
  List<Object> get props => [message];
}

class ErrorState extends ForecastState {
  final String message;

  ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class ChangeCityState extends ForecastState {
  final String city;

  const ChangeCityState(this.city);

  @override
  List<Object> get props => [city];
}

class LogOut extends ForecastState{}

extension AuthStateExtention on ForecastState {
  List<Object> get getProps {
    final state = this;
    if (state is ChangeCityState) return state.props;
    if (state is ErrorState) return state.props;
    if (state is WrongCityState) return state.props;
    return [];
  }
}
