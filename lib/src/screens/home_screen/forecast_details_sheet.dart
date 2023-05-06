// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:weather_app_dart_client/weather_app_dart_client.dart';

class ForecastDetailSheet extends StatelessWidget {
  const ForecastDetailSheet({
    required this.day,
    required this.weather,
    required this.place,
    super.key,
  });

  final Weather weather;
  final String day;
  final String? place;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFF213056),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 42),
                  Text(
                    day,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.orange,
                        ),
                  ),
                  Text(
                    'in',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w200,
                          fontSize: 20,
                          color: Colors.blueGrey,
                        ),
                  ),
                  Text(
                    place!,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.orange,
                        ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: weather.main.temp.round().toString(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 80,
                                color: Colors.orange,
                              ),
                        ),
                        TextSpan(
                          text: '°C',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.orange,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SunnyDayTile(
                    unit: weather.main.humidity,
                    scale: '%',
                    title: 'Humidity',
                    icon: LineIcons.water,
                  ),
                  const SizedBox(height: 24),
                  SunnyDayTile(
                    unit: weather.visibility,
                    scale: 'm',
                    title: 'Visibility',
                    icon: LineIcons.eye,
                  ),
                  const SizedBox(height: 24),
                  SunnyDayTile(
                    unit: weather.clouds.all,
                    scale: '%',
                    title: 'Clouds',
                    icon: LineIcons.cloud,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SunnyDaySquareTile(
                        unit: weather.wind.deg,
                        scale: '°',
                        title: 'wind degrees',
                        icon: LineIcons.wind,
                      ),
                      SunnyDaySquareTile(
                        unit: weather.wind.gust.round(),
                        scale: 'm/s',
                        title: 'Gust',
                        icon: LineIcons.wind,
                      ),
                      SunnyDaySquareTile(
                        unit: weather.wind.speed.round(),
                        title: 'Wind speed',
                        icon: LineIcons.wind,
                        scale: 'm/s',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SunnyDayTile(
                    unit: weather.main.pressure,
                    title: 'Pressure',
                    icon: LineIcons.pushed,
                    scale: 'hPa',
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SunnyDayTile extends StatelessWidget {
  const SunnyDayTile({
    required this.unit,
    required this.scale,
    required this.title,
    required this.icon,
    super.key,
  });

  factory SunnyDayTile.square({
    required int unit,
    required String scale,
    required String title,
    required IconData icon,
  }) {
    return SunnyDayTile(
      unit: unit,
      scale: scale,
      title: title,
      icon: icon,
    );
  }

  final int unit;
  final String scale;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange,
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$unit$scale',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SunnyDaySquareTile extends StatelessWidget {
  const SunnyDaySquareTile({
    required this.unit,
    required this.title,
    required this.icon,
    required this.scale,
    super.key,
  });

  final int unit;
  final String title;
  final IconData icon;
  final String scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$unit',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: scale,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
