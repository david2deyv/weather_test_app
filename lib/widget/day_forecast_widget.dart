import 'package:flutter/material.dart';
import 'package:weather_test_app/models/day_weather.dart';
import 'package:weather_test_app/models/weather_forecast_daily_one.dart';
import 'package:weather_test_app/utilites/forecast_util.dart';

import 'current_temp_widget.dart';
import 'days_forecast_widget.dart';
import 'detail_view_widget.dart';

class DaysForecastWidget extends StatelessWidget {
  const DaysForecastWidget({required this.days, required this.forecast,});

  final List<DayWeather> days;
  final WeatherForecast forecast;



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, int index) {
          final String fullDate = Util.getFormattedDate(days[index].date);
          final String dayOfWeek = fullDate.split(',').first;
          final String averageTemp = days[index].averageTemp.toStringAsFixed(0);
          return InkWell(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      elevation: 16,
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        height: 400.0,
                        width: 360.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          Text(
                            dayOfWeek,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 45.0,
                                color: Colors.white
                            ),
                          ),
                          CurrentTempWidget(forecast: forecast.list![index], averageTemp: averageTemp,),
                          SizedBox(height: 30),
                          DetailView(forecastItem: forecast.list![index],),
                        ],)
                      ),
                    );
                  });
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 3.1,
              child: forecastCard(days[index], context),
            ),
          );
        },
      ),
      // ListView.separated(
      //   scrollDirection: Axis.horizontal,
      //   separatorBuilder: (context, index) => SizedBox(width: 8),
      //   itemCount: days.length,
      //   itemBuilder: (context, int index) {
      //     return Container(
      //       width: MediaQuery.of(context).size.width / 3.1,
      //       child: forecastCard(days[index], context),
      //     );
      //   },
      // ),
    );
  }
}
