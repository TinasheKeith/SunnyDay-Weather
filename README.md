# SunnyDay-Weather

SunnyDay-Weather is a simple weather application that provides up-to-date weather information for cities around the world. This project was built using the Flutter framework and utilizes the OpenWeatherMap and Google Places API to provide real-time weather data.

## Setup

### To run the project locally, follow these steps:

Clone the repository:
```bash
git clone https://github.com/TinasheKeith/SunnyDay-Weather.git
```

1. Install Flutter and Dart if you haven't already. For instructions, see the Flutter installation guide.
2. Create a new project on the OpenWeatherMap website and obtain an API key.
3. Create a new project on the Google Cloud Platform Console and obtain an API key for the Places API.

4. In the project root, create a .vscode foler, in which you can include a launch.json with the app configurations for dev, staging and prod:
```json
{
    "version": "0.2.0",
    "configurations": [
      {
        "name": "Development",
        "program": "lib/main_dev.dart",
        "request": "launch",
        "type": "dart",
        "args": [
            "--dart-define=FLAVOR=dev",
            "--dart-define",
            "OPEN_WEATHER_KEY=<your_open_weather_api_key>",
            "--dart-define",
            "GOOGLE_PLACES_KEY=<your_google_places_key>"
        ],
      },
      {
        "name": "Staging",
        "program": "lib/main_staging.dart",
        "request": "launch",
        "type": "dart",
        "args": [
            "--dart-define=FLAVOR=dev",
            "--dart-define",
            "OPEN_WEATHER_KEY=<your_open_weather_api_key>",
            "--dart-define",
            "GOOGLE_PLACES_KEY=<your_google_places_key>"
        ],
      },
      {
        "name": "Production",
        "program": "lib/main_prod.dart",
        "request": "launch",
        "type": "dart",
        "args": [
            "--dart-define=FLAVOR=dev",
            "--dart-define",
            "OPEN_WEATHER_KEY=<your_open_weather_api_key>",
            "--dart-define",
            "GOOGLE_PLACES_KEY=<your_google_places_key>"
        ],
      }
    ]
  }
```

5. Replace <your_open_weather_api_key> and <your_google_places_api_key> with the keys you obtained in steps 2 and 3.
6. From the project root, run the following command to install the required dependencies:
```bash
flutter pub get
```

7. You should be golden! Launch the app with one of the environment configurations; dev, staging, or prod.

## Features

### SunnyDay-Weather provides the following features:

* View current weather information for any city in the world
* Search for cities by name or location
* View detailed information about weather conditions, including temperature, humidity, wind speed, and more
* View a 5-day weather forecast for any city
* Save your favorite cities for quick access to weather information
* Offline ready
* A wallpaper that matches the weather conditions
* pull to refresh to make sure you always stay informed with the most up-to-date information

## Technical Considerations:

### Architecture

This project follows MVVM so I try to get as much separation between the view and business logic as possible. My ViewModel would extend the ChangeNotifier class as notify the view should any of it's data fields update. I also made use of a Service Locator to further decouple aspects of SunnyDay

I chose to persue Provider/Change Notifier for this project for 2 reasons:
1. Familiarity. I have worked with several iterations of the BLoC pattern from the purely streams approach, to the very early versions of the flutter_bloc and to the later BLoC/Cubit approach, 
and although BLoC has strong benefits regarding structure, reactivity and testability, I just have too little exposure to it for me to deliver very quickly at this point.
2. I feel that for an application of this size, and with these requirements, Provider is more than sufficient to get the job done.
3. There are aspects of the BLoC pattern that the BLoC library's documentation highlight which I did adopt for this project, and that is data layer separation. The benefit being the promise of modularity by decoupling parts of the code base. With regard to SunnyDay, I built dart_open_weather_client as a separate project [https://github.com/TinasheKeith/dart_open_weather_client] that is self contained and could be useful for later projects (or improved and published to [https://pub.dev]!).

### Architecture Takeaways
* There certainly areas where I feel in hindsight, I can see how BLoC could have helped me move faster and the biggest of which is debugging. I think that one big benefit of BLoC is the ease at which it is to monitor the flow of events within the app and easily find where a problem lies.

* I find that Provider's benefit of flexibility can sometimes be a double edged sword, because one has to consiously make sure that convensions are kept consistent. Toward the end of the project, because I wanted to move quickly, I had to make some omissions which if not corrected before further features are added, I feel could lead the codebase to becoming a nightmare in future.

### Convensions
* This project was built using flutter skeleton template, which was introduced in flutter 2.5 [https://www.youtube.com/watch?v=Yy4NgbqNNtY] which already had a few goodies baked in such as localisations (which Ironically, I could not get working [https://github.com/flutter/flutter/issues/99741]) and then ultimately decided to code the raw strings into the Text widgets etc, which is less than ideal.

* For linting, I chose to go with VeryGoodAnalysis [https://verygood.ventures/blog/introducing-very-good-analysis], built and maintained by the very well known VeryGoodVentures. 


# Improvements
- localisation
- linting
- error handling
- location permissions
Contributing

Contributions to this project are welcome. If you find a bug or would like to suggest a new feature, please submit an issue or pull request.