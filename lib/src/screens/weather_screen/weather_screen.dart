// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunny_day/src/screens/weather_screen/weather_screen_view_model.dart';
import 'package:sunny_day/src/shared/search_bar.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherScreenViewModel(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: SunnyDaySearchBar(),
              ),
              Center(
                child: Consumer<WeatherScreenViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.currentWeather == null &&
                        viewModel.userPosition != null) {
                      viewModel.getCurrentWeather(
                        viewModel.userPosition!.latitude,
                        viewModel.userPosition!.longitude,
                      );

                      return const CircularProgressIndicator();
                    }

                    if (viewModel.currentWeather != null) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${viewModel.kelvinToCelsius(
                              viewModel.currentWeather!.main.temp,
                            )}°C',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            viewModel.currentWeather!.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            viewModel.currentWeather!.weather.first.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      );
                    }

                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationPermissionRequiredWidget extends StatelessWidget {
  const LocationPermissionRequiredWidget(
    this._viewModel, {
    super.key,
  });

  final WeatherScreenViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('To continue, SunnyDay requires access to your location.'),
        ElevatedButton(
          child: const Text('Enable'),
          onPressed: () async {
            await _viewModel.hasLocationPermissions();
          },
        ),
      ],
    );
  }
}
