// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sunny_day/src/screens/home_screen/home_screen.dart';

import 'package:sunny_day/src/screens/home_screen/home_screen_view_model.dart';
import 'package:sunny_day/src/screens/location_search_screen/location_search_screen.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(
        canvasColor: const Color(0xFFF5F5F5),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => HomeScreenViewModel(),
                  ),
                ],
                child: const HomeScreen(),
              ),
            );
          case LocationSearchScreen.id:
            return MaterialPageRoute(
              builder: (_) => LocationSearchScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => HomeScreenViewModel(),
                  ),
                ],
                child: const HomeScreen(),
              ),
            );
        }
      },
    );
  }
}
