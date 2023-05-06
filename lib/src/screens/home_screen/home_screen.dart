import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunny_day/src/screens/home_screen/forecast_details_sheet.dart';
import 'package:sunny_day/src/screens/home_screen/home_screen_view_model.dart';
import 'package:sunny_day/src/shared/loading_widget.dart';
import 'package:weather_app_dart_client/weather_app_dart_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            closeIconColor: Colors.white,
            duration: Duration(
              days: 1,
            ),
            content: Text(
              // ignore: lines_longer_than_80_chars
              'No internet? Just look out the window and take a wild guess at the weather!',
            ),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<HomeScreenViewModel, int>(
      selector: (context, viewModel) => viewModel.themeColor,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Color(value),
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  final viewModel = context.read<HomeScreenViewModel>();

                  try {
                    await viewModel.getCurrentWeather(
                      viewModel.userPosition!.latitude,
                      viewModel.userPosition!.longitude,
                    );

                    await viewModel.getWeatherForecast(
                      viewModel.userPosition!.latitude,
                      viewModel.userPosition!.longitude,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                        closeIconColor: Colors.white,
                        duration: Duration(
                          days: 1,
                        ),
                        content: Text(
                          'Updated forecasts! ☀️',
                        ),
                      ),
                    );
                  } catch (e) {}
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      stops: const [
                        0.0,
                        0.33,
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<HomeScreenViewModel>(
                          builder: (context, viewModel, child) {
                            if (viewModel.currentWeather == null &&
                                viewModel.userPosition != null) {
                              viewModel
                                ..getCurrentWeather(
                                  viewModel.userPosition!.latitude,
                                  viewModel.userPosition!.longitude,
                                )
                                ..getWeatherForecast(
                                  viewModel.userPosition!.latitude,
                                  viewModel.userPosition!.longitude,
                                );

                              return const Center(
                                child: SpinningCloudWidget(),
                              );
                            }

                            if (viewModel.currentWeather != null &&
                                viewModel.weatherForecast != null) {
                              return Column(
                                children: [
                                  _CurrentWeatherWidget(viewModel),
                                  _ForecastedWeatherWidget(
                                    viewModel.weatherForecast!,
                                    viewModel,
                                  )
                                ],
                              );
                            }

                            return const Center(
                              child: SpinningCloudWidget(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CurrentWeatherWidget extends StatelessWidget {
  const _CurrentWeatherWidget(this.viewModel);

  final HomeScreenViewModel viewModel;

  int _kelvinToCelsius(double temperatureInKelvin) {
    return (temperatureInKelvin - 273.15).round();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<HomeScreenViewModel, String>(
      selector: (context, viewModel) => viewModel.homescreenBackground,
      builder: (context, value, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                value,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${_kelvinToCelsius(
                        viewModel.currentWeather!.main.temp,
                      )}',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 80,
                                color: Colors.white,
                              ),
                    ),
                    TextSpan(
                      text: '°C',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.currentWeather!.name,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.currentWeather!.weather.first.description,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TemperatureTile(
                    temperature: viewModel.currentWeather!.main.tempMin,
                    title: 'Min',
                  ),
                  _TemperatureTile(
                    temperature: viewModel.currentWeather!.main.tempMax,
                    title: 'Max',
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        );
      },
    );
  }
}

class _ForecastedWeatherWidget extends StatelessWidget {
  const _ForecastedWeatherWidget(this.forecast, this._viewModel);

  final WeatherForecast forecast;
  final HomeScreenViewModel _viewModel;

  static final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daysOfWeek =
        List.generate(5, (i) => _daysOfWeek[(today.weekday + i) % 7]);

    return Column(
      children: [
        ...forecast.list.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final value = entry.value;
            final dayOfWeek = daysOfWeek[index];

            return Column(
              children: [
                ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      builder: (BuildContext context) {
                        return ForecastDetailSheet(
                          day: dayOfWeek,
                          weather: value,
                          place: _viewModel.currentWeather?.name,
                        );
                      },
                    );
                  },
                  leading: SizedBox(
                    width: 80,
                    child: Text(
                      dayOfWeek,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: _ForecastTile(
                    minTemp: value.main.tempMin,
                    maxTemp: value.main.tempMax,
                    viewModel: _viewModel,
                    weather: value.weather.last,
                  ),
                ),
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  height: 1,
                  indent: 12,
                  endIndent: 12,
                  thickness: .5,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

class _ForecastTile extends StatelessWidget {
  const _ForecastTile({
    required this.maxTemp,
    required this.minTemp,
    required this.weather,
    required this.viewModel,
  });

  final double maxTemp;
  final double minTemp;
  final WeatherInfo weather;
  final HomeScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Icon(
          viewModel.getWeatherIcon(weather),
          color: Colors.white,
        ),
        const Spacer(),
        Text(
          '${minTemp.round().toString()}°C - ${maxTemp.round().toString()}°C',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        const Icon(
          Icons.arrow_right,
          color: Colors.white,
        )
      ],
    );
  }
}

class _TemperatureTile extends StatelessWidget {
  const _TemperatureTile({
    required this.title,
    required this.temperature,
  });

  final double temperature;
  final String title;

  int _kelvinToCelsius(double temperatureInKelvin) {
    return (temperatureInKelvin - 273.15).round();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$title ${_kelvinToCelsius(temperature).toString()}',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
          ),
          TextSpan(
            text: '°C',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
