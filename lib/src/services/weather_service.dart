// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:sunny_day/src/locator.dart';
import 'package:sunny_day/src/services/shared_preferences_service.dart';
import 'package:weather_app_dart_client/weather_app_dart_client.dart';

class WeatherService {
  WeatherService({required String apiKey}) {
    _client = WeatherAppDartClient(apiKey: apiKey);

    _preferencesService.getCurrentWeather().then(
      (currentWeather) {
        if (currentWeather != null) {
          _currentWeatherController.add(currentWeather);
        }
      },
    );

    _preferencesService.getWeatherForecast().then(
      (forecast) {
        if (forecast != null) {
          _weatherForecastController.add(forecast);
        }
      },
    );
  }

  late final WeatherAppDartClient _client;

  final SharedPreferencesService _preferencesService =
      locator<SharedPreferencesService>();

  final _currentWeatherController =
      StreamController<CurrentWeather>.broadcast();

  final _weatherForecastController =
      StreamController<WeatherForecast>.broadcast();

  Stream<CurrentWeather> get currentWeatherStream =>
      _currentWeatherController.stream;

  Stream<WeatherForecast> get weatherForecastStream =>
      _weatherForecastController.stream;

  Future<void> updateCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final currentWeather = await _client.getWeatherData(
        latitude,
        longitude,
      );
      _currentWeatherController.add(currentWeather);

      await _preferencesService.saveCurrentWeather(currentWeather);
    } catch (e) {
      print('Error updating current weather: $e');
    }
  }

  Future<void> updateWeatherForecast({
    required double latitude,
    required double longitude,
    int days = 5,
    TemperatureScale? units,
  }) async {
    try {
      final weatherForecast = await _client.getForecastData(
        latitude,
        longitude,
        units: units,
        days: days,
      );

      _weatherForecastController.add(weatherForecast);

      await _preferencesService.saveWeatherForecast(weatherForecast);
    } catch (e) {
      print('Error updating weather forecast: $e');
    }
  }

  void dispose() {
    _currentWeatherController.close();
    _weatherForecastController.close();
  }
}
