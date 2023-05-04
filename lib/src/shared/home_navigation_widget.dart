// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sunny_day/src/providers/bottom_navigation_provider.dart';
import 'package:sunny_day/src/screens/favourites_screen/favourites_screen.dart';
import 'package:sunny_day/src/screens/weather_screen/weather_screen.dart';
import 'package:sunny_day/src/screens/weather_screen/weather_screen_view_model.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final List<Widget> _pages = [
    const WeatherScreen(),
    const FavouritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.select(
          (BottomNavigationProvider provider) => provider.currentIndex,
        ),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: context.watch<BottomNavigationProvider>().currentIndex,
        onTap: (index) =>
            context.read<BottomNavigationProvider>().currentIndex = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              LineIcons.sun,
              color: Colors.black,
            ),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              LineIcons.mapMarked,
              color: Colors.black,
            ),
            label: 'Your places',
          ),
        ],
      ),
    );
  }
}
