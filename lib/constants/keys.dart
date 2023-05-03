/// This class provides access to various API keys used in the app.
///
/// `openWeatherKey`: The API key for the OpenWeather API.
class Keys {
  /// The API key for the OpenWeather API.
  static const openWeatherKey = String.fromEnvironment('OPEN_WEATHER_KEY');
}
