import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_test_app/models/weather_forecast_daily_one.dart';
import 'package:weather_test_app/utilites/forecast_util.dart';

class DetailView extends StatelessWidget {
  final ForecastItem forecastItem;
  const DetailView({required this.forecastItem});

  @override
  Widget build(BuildContext context) {
    final double pressure = forecastItem.main!.pressure! * 0.750062;
    final int? humidity = forecastItem.main!.humidity;
    final double? windSpeed = forecastItem.wind!.speed;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Util.getItem(context, FontAwesomeIcons.thermometerThreeQuarters,
            pressure.round(), 'mm Hg'),
        Util.getItem(context, FontAwesomeIcons.cloudRain, humidity!, '%'),
        Util.getItem(context, FontAwesomeIcons.wind, windSpeed!.toInt(), 'm/s'),
      ],
    );
  }
}