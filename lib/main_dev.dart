import 'package:flutter/material.dart';
import 'package:sunny_day/constants/flavor.dart';

import 'package:sunny_day/src/app.dart';
import 'package:sunny_day/src/locator.dart';

void main() {
  setupLocator(flavor: Flavor.dev);

  runApp(
    const App(),
  );
}
