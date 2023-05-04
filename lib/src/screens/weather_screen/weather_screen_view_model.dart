// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sunny_day/src/locator.dart';
import 'package:sunny_day/src/services/location_service.dart';
import 'package:sunny_day/src/services/weather_service.dart';
import 'package:weather_app_dart_client/weather_app_dart_client.dart';

class WeatherScreenViewModel extends ChangeNotifier {
  WeatherScreenViewModel() {
    getUserPosition();
    _weatherService.currentWeatherStream.first;
  }

  final WeatherService _weatherService = locator<WeatherService>();
  final LocationService _locationService = locator<LocationService>();

  Position? _userPosition;
  Position? get userPosition => _userPosition;

  LocationPermissionStatus? _locationPermissionStatus;
  LocationPermissionStatus? get locationPermissionStatus =>
      _locationPermissionStatus;

  CurrentWeather? _currentWeather;
  CurrentWeather? get currentWeather => _currentWeather;

  WeatherForecast? _weatherForecast;
  WeatherForecast? get weatherForecast => _weatherForecast;

  Stream<CurrentWeather?> get currentWeatherStream =>
      _weatherService.currentWeatherStream;

  Stream<WeatherForecast?> get weatherForecastStream =>
      _weatherService.weatherForecastStream;

  Future<bool> hasLocationPermissions() async {
    final permission = await _locationService.checkPermission();

    _locationPermissionStatus = permission;
    notifyListeners();

    if (permission == LocationPermissionStatus.granted) {
      return true;
    }

    return false;
  }

  Future<bool> requestLocationPermission() async {
    final permission = await _locationService.requestPermission();

    _locationPermissionStatus = permission;
    notifyListeners();

    if (permission == LocationPermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  int kelvinToCelsius(double temperatureInKelvin) {
    return (temperatureInKelvin - 273.15).ceil();
  }

  Future<void> getCurrentWeather(double latitude, double longitude) async {
    try {
      final weather = await _weatherService.updateCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );

      _currentWeather = weather;
    } catch (e) {}

    notifyListeners();
  }

  Future<void> updateWeatherForecast(double latitude, double longitude) async {
    notifyListeners();

    try {
      await _weatherService.updateWeatherForecast(
        latitude: latitude,
        longitude: longitude,
      );
      _weatherForecast = await _weatherService.weatherForecastStream.first;
    } catch (e) {}

    notifyListeners();
  }

  Future<void> getUserPosition() async {
    _userPosition = await _locationService.getCurrentPosition();
    notifyListeners();
  }

  @override
  void dispose() {
    _weatherService.dispose();
    super.dispose();
  }
}
