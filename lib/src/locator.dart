import 'package:get_it/get_it.dart';
import 'package:sunny_day/constants/flavor.dart';
import 'package:sunny_day/constants/keys.dart';
import 'package:sunny_day/src/services/location_service.dart';
import 'package:sunny_day/src/services/shared_preferences_service.dart';
import 'package:sunny_day/src/services/weather_service.dart';


/// Locator instance
GetIt locator = GetIt.instance;

/// Sets up the GetIt service locator with singleton instances of services
/// needed throughout the app.
///
/// [flavor] determines the environment in which the app is running.
///
/// Registers a singleton instance of [WeatherService] with the
/// API key [Keys.openWeatherKey] as a dependency.
///
/// Registers a singleton instance of [LocationService] as a
/// dependency.
///
/// Registers a singleton instance of [SharedPreferencesService] with [flavor]
/// as a dependency.
void setupLocator({
  required Flavor flavor,
}) {
  // Registering lazy singletons
  locator
    ..registerLazySingleton(
      () => WeatherService(apiKey: Keys.openWeatherKey),
    )
    ..registerLazySingleton(
      LocationService.new,
    )
    ..registerLazySingleton(
      () => SharedPreferencesService(flavor),
    );
}
