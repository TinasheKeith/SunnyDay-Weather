// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny_day/constants/flavor.dart';
import 'package:weather_app_dart_client/weather_app_dart_client.dart';

class SharedPreferencesService {
  SharedPreferencesService(Flavor flavor) {
    _storageKey = flavor.name;
  }
  late String _storageKey;

  SharedPreferences? _preferences;

  Future<SharedPreferences> get preferences async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> saveWeatherForecast(WeatherForecast forecast) async {
    final key = '$_storageKey/weather_forecast';
    final data = jsonEncode(forecast.toJson());
    final prefs = await preferences;
    await prefs.setString(key, data);
  }

  Future<WeatherForecast?> getWeatherForecast() async {
    final key = '$_storageKey/weather_forecast';
    final prefs = await preferences;
    final data = prefs.getString(key);
    if (data == null) {
      return null;
    }
    final map = jsonDecode(data) as Map<String, dynamic>;
    return WeatherForecast.fromJson(map);
  }

  Future<void> saveCurrentWeather(CurrentWeather currentWeather) async {
    final key = '$_storageKey/current_weather';
    final data = jsonEncode(currentWeather.toJson());
    final prefs = await preferences;
    await prefs.setString(key, data);
  }

  Future<CurrentWeather?> getCurrentWeather() async {
    final key = '$_storageKey/current_weather';
    final prefs = await preferences;
    final data = prefs.getString(key);
    if (data == null) {
      return null;
    }
    final map = jsonDecode(data) as Map<String, dynamic>;
    return CurrentWeather.fromJson(map);
  }
}
