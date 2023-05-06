// ignore_for_file: public_member_api_docs
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sunny_day/constants/assets.dart';
import 'package:sunny_day/constants/colors.dart';
import 'package:sunny_day/src/locator.dart';
import 'package:sunny_day/src/services/location_service.dart';
import 'package:sunny_day/src/services/weather_service.dart';
import 'package:weather_app_dart_client/weather_app_dart_client.dart';

class HomeScreenViewModel extends ChangeNotifier {
  HomeScreenViewModel() {
    getUserPosition();

    _weatherService.currentWeatherStream.first.then((value) {
      if (_currentWeather == null) {
        _currentWeather = value;
        notifyListeners();
      }
    });

    _weatherService.weatherForecastStream.first.then((value) {
      if (_weatherForecast == null) {
        _weatherForecast = value;
        notifyListeners();
      }
    });
  }

  final WeatherService _weatherService = locator<WeatherService>();
  final LocationService _locationService = locator<LocationService>();

  int _themeColor = SunnyDayColors.sunny;
  int get themeColor => _themeColor;

  String _homescreenBackground = Assets.seaSunny;
  String get homescreenBackground => _homescreenBackground;

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

  Future<void> getCurrentWeather(double latitude, double longitude) async {
    try {
      final weather = await _weatherService.updateCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );

      _currentWeather = weather;

      updateHomescreenTheme(weather!.weather.first);
      notifyListeners();
    } catch (e) {}

    notifyListeners();
  }

  IconData getWeatherIcon(WeatherInfo weather) {
    final main = weather.main;
    final description = weather.description;

    switch (main.toLowerCase()) {
      case 'thunderstorm':
        return LineIcons.lightningBolt;
      case 'drizzle':
        return LineIcons.cloudWithSunAndRain;
      case 'rain':
        return LineIcons.cloudWithHeavyShowers;
      case 'snow':
        return LineIcons.snowflake;
      case 'atmosphere':
        return LineIcons.sun;
      case 'clear':
        return LineIcons.sun;
      case 'clouds':
        if (description.toLowerCase().contains('few clouds')) {
          return LineIcons.cloud;
        } else if (description.toLowerCase().contains('scattered clouds')) {
          return LineIcons.cloud;
        } else if (description.toLowerCase().contains('broken clouds') ||
            description.toLowerCase().contains('overcast clouds')) {
          return LineIcons.cloud;
        }
        break;
      default:
        return LineIcons.sun;
    }
    return LineIcons.sun;
  }

  void updateHomescreenTheme(CurrentWeatherData weather) {
    final main = weather.main;

    switch (main.toLowerCase()) {
      case 'thunderstorm':
        _themeColor = SunnyDayColors.rainy;
        _homescreenBackground = Assets.seaRainy;
        notifyListeners();
        break;
      case 'drizzle':
        _themeColor = SunnyDayColors.rainy;
        _homescreenBackground = Assets.seaRainy;
        notifyListeners();
        break;
      case 'rain':
        _themeColor = SunnyDayColors.rainy;
        _homescreenBackground = Assets.seaRainy;
        notifyListeners();
        break;
      case 'snow':
        _themeColor = SunnyDayColors.cloudy;
        _homescreenBackground = Assets.seaCloudy;
        notifyListeners();
        break;
      case 'atmosphere':
        _themeColor = SunnyDayColors.cloudy;
        _homescreenBackground = Assets.seaCloudy;
        notifyListeners();
        break;
      case 'clear':
        _themeColor = SunnyDayColors.sunny;
        _homescreenBackground = Assets.seaSunny;
        notifyListeners();
        break;
      case 'clouds':
        _themeColor = SunnyDayColors.cloudy;
        _homescreenBackground = Assets.seaCloudy;
        notifyListeners();
        break;
      default:
        _themeColor = SunnyDayColors.cloudy;
        _homescreenBackground = Assets.seaCloudy;
        notifyListeners();
    }
  }

  Future<void> getWeatherForecast(double latitude, double longitude) async {
    try {
      final forecast = await _weatherService.updateWeatherForecast(
        latitude: latitude,
        longitude: longitude,
      );

      _weatherForecast = forecast;
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
