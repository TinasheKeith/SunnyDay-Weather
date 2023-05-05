import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunny_day/constants/flavor.dart';

import 'package:sunny_day/src/app.dart';
import 'package:sunny_day/src/locator.dart';
import 'package:sunny_day/src/providers/bottom_navigation_provider.dart';

void main() {
  setupLocator(flavor: Flavor.staging);

  runApp(
    ChangeNotifierProvider(
      create: (_) => BottomNavigationProvider(),
      child: const App(),
    ),
  );
}
