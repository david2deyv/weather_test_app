import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_test_app/models/weather_forecast_daily_one.dart';

class CurrentTempWidget extends StatelessWidget {
  final ForecastItem forecast;
  final String? averageTemp;

  const CurrentTempWidget({
    Key? key,
    required this.forecast,
    this.averageTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dynamic color = Colors.white;
    final String icon = forecast.getIconUrl();
    final String temp = averageTemp ?? forecast.main!.temp!.toStringAsFixed(0);
    final String description = forecast.weather![0].description!.toUpperCase();

    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  '$temp °С',
                  style: TextStyle(
                    fontSize: 54.0,
                    color: color,
                  ),
                ),
              ],
            ),
            CachedNetworkImage(
              imageUrl: icon,
              height: 120,
              width: 120,
              color: color,
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          '$description',
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 26.0,
            color: color,
          ),
        ),
      ]),
    );
  }
}
