import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sunny_day/src/locator.dart';
import 'package:sunny_day/src/model/saved_location_model.dart';
import 'package:sunny_day/src/services/shared_preferences_service.dart';

class SunnyDayDrawer extends StatefulWidget {
  const SunnyDayDrawer({super.key});

  @override
  State<SunnyDayDrawer> createState() => _SunnyDayDrawerState();
}

class _SunnyDayDrawerState extends State<SunnyDayDrawer> {
  @override
  void initState() {
    super.initState();

    locator<SharedPreferencesService>().getSavedLocations().then(
      (locations) {
        setState(
          () {
            _savedLocations = locations;
          },
        );
      },
    );
  }

  List<SavedLocation> _savedLocations = [];

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      width: MediaQuery.of(context).size.width * 0.9,
      elevation: 0,
      surfaceTintColor: secondaryColor,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.mapMarked,
                  color: secondaryColor,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Text(
                  'Your saved locations',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: secondaryColor,
                      ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Divider(
              color: secondaryColor,
              indent: 16,
              endIndent: 16,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _savedLocations.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    color: secondaryColor,
                    indent: 16,
                    endIndent: 16,
                  );
                },
                itemBuilder: (context, index) {
                  final location = _savedLocations[index];
                  return ListTile(
                    title: Text(
                      location.placeName,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    onTap: () {
                      Navigator.pop(context, location);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
