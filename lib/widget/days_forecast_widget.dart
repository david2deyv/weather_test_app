import 'package:flutter/material.dart';
import 'package:weather_test_app/models/day_weather.dart';
import 'package:weather_test_app/utilites/forecast_util.dart';

Widget forecastCard(DayWeather dayWeather, BuildContext context) {
  final Color color = Colors.white;
  final String fullDate = Util.getFormattedDate(dayWeather.date);
  final String dayOfWeek = fullDate.substring(0, 3);
  final String averageTemp = dayWeather.averageTemp.toStringAsFixed(0);
  return Row(children: [
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              dayOfWeek,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 25,
                color: color,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            '$averageTemp °С',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
        ),
      ],
    ),
    Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Image.network(
        dayWeather.iconUrl,
        scale: 0.8,
        color: color,
      ),
    ),
  ]);
}
