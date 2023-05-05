// ignore_for_file: public_member_api_docs, noop_primitive_operations

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunny_day/constants/assets.dart';
import 'package:sunny_day/constants/connectivity_messages.dart';
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
          SnackBar(
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            closeIconColor: Colors.white,
            duration: const Duration(
              days: 1,
            ),
            content: Text(
              // ignore: lines_longer_than_80_chars
              ConnectivityMessages.getMessage(),
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
    return ChangeNotifierProvider(
      create: (_) => HomeScreenViewModel(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF4a90e2),
          body: SingleChildScrollView(
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
                          _CurrentWeatherWidget(viewModel.currentWeather!),
                          _ForecastedWeatherWidget(viewModel.weatherForecast!)
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
    );
  }
}

class _CurrentWeatherWidget extends StatelessWidget {
  const _CurrentWeatherWidget(this.currentWeather);

  final CurrentWeather currentWeather;

  int _kelvinToCelsius(double temperatureInKelvin) {
    return (temperatureInKelvin - 273.15).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.seaSunny),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${_kelvinToCelsius(currentWeather.main.temp)}',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 80,
                        color: Colors.white,
                      ),
                ),
                TextSpan(
                  text: '°C',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            currentWeather.name,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            currentWeather.weather.first.description,
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
                temperature: currentWeather.main.tempMin,
                title: 'Min',
              ),
              _TemperatureTile(
                temperature: currentWeather.main.tempMax,
                title: 'Max',
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _ForecastedWeatherWidget extends StatelessWidget {
  const _ForecastedWeatherWidget(this.forecast);

  final WeatherForecast forecast;

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

            return ListTile(
              leading: Text(
                dayOfWeek,
                style: const TextStyle(color: Colors.white),
              ),
              title: _TemperatureMinMaxWidget(
                minTemp: value.main.tempMin,
                maxTemp: value.main.tempMax,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TemperatureMinMaxWidget extends StatelessWidget {
  const _TemperatureMinMaxWidget({
    required this.maxTemp,
    required this.minTemp,
  });

  final double maxTemp;
  final double minTemp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${minTemp.ceil().toString()} - ${maxTemp.ceil().toString()}',
          style: const TextStyle(color: Colors.white),
        ),
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
    return (temperatureInKelvin - 273.15).ceil();
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
