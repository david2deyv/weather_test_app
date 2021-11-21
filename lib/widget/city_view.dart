import 'package:flutter/material.dart';
import 'package:weather_test_app/models/weather_forecast_daily_one.dart';
import 'package:weather_test_app/utilites/forecast_util.dart';

class CityView extends StatelessWidget {
  final City city;
  final DateTime date;

  const CityView({
    Key? key,
    required this.city,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15, top: 20),
      child: Column(
        children: <Widget>[
          Text(
            '${city.name}',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 45.0,
              color: Colors.white
            ),
          ),
          Text(
            '${Util.getFormattedDate(date)}',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
