// import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test_app/api/weather_repository.dart';
import 'package:weather_test_app/cubit/forecast_cubit.dart';
import 'package:weather_test_app/models/weather_forecast_daily_one.dart';
import 'package:weather_test_app/widget/city_view.dart';
import 'package:weather_test_app/widget/current_temp_widget.dart';
import 'package:weather_test_app/widget/day_forecast_widget.dart';
import 'package:weather_test_app/widget/detail_view_widget.dart';
import 'package:weather_test_app/widget/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();
  bool isSwitched = false;

  Decoration decoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blueGrey,
        Colors.blueGrey,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ForecastCubit(WeatherRepositoryImpl())..firstLoadWeather(),
      child: BlocConsumer<ForecastCubit, ForecastState>(
        listener: (context, state) {
          if (state is WrongCityState || state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                state.getProps.first.toString(),
              ),
            ));
          }
        },
        builder: (context, state) {
          Widget body = Container();

          if (state is LoadingState) {
            body = Container(
              decoration: decoration,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
          if (state is LoadedState) {
            final WeatherForecast weatherForecast = state.forecast;
            final ForecastItem currentForecast = weatherForecast.list!.first;
            final City city = weatherForecast.city!;
            final DateTime date =
                DateTime.fromMillisecondsSinceEpoch(currentForecast.dt! * 1000);

            body = Container(
              decoration: decoration,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: searchBar(context),
                  ),
                  Expanded(
                    child: ListView(children: [
                      CityView(city: city, date: date),
                      SizedBox(height: 40),
                      CurrentTempWidget(forecast: currentForecast),
                      SizedBox(height: 40),
                      isSwitched
                          ? DetailView(forecastItem: currentForecast)
                          : SizedBox(height: 80),
                      SizedBox(height: 60),
                      DaysForecastWidget(
                        days: weatherForecast.daysForecast,
                        forecast: weatherForecast,
                      ),
                    ]),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: decoration,
                    child: Text(
                      'Settings',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

                    title: Text(
                      'Show details',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      isSwitched ? 'Enabled' : 'Disabled',
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print(isSwitched);
                        });
                      },
                      activeTrackColor: Colors.blueGrey,
                      activeColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              title: Text('Weather App'),
              actions: [
                IconButton(
                    icon: Icon(Icons.my_location),
                    onPressed: () {
                      context.read<ForecastCubit>()..loadWeatherByLocation();
                    }),
              ],
            ),
            body: body,
          );
        },
      ),
      // ),
      //
    );
  }

  Widget searchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: AnimSearchBar(
        helpText: 'City...',
        suffixIcon: Icon(Icons.search),
        closeSearchOnSuffixTap: true,
        rtl: true,
        width: 400,
        textController: textController,
        onSuffixTap: () {
          final city = textController.text;
          if (city != '') {
            context.read<ForecastCubit>()..changeCityEvent(city);
            textController.clear();
          } else {
            textController.clear();
          }
        },
      ),
    );
  }
}
