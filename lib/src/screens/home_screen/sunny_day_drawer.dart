import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sunny_day/src/locator.dart';
import 'package:sunny_day/src/model/saved_location_model.dart';
import 'package:sunny_day/src/screens/location_search_screen/location_search_screen.dart';
import 'package:sunny_day/src/services/shared_preferences_service.dart';

typedef OnSavePlaceCallback = void Function(double latitude, double longitude);

class SunnyDayDrawer extends StatefulWidget {
  const SunnyDayDrawer({
    required this.onSavedPlaceCallback,
    super.key,
  });

  final OnSavePlaceCallback onSavedPlaceCallback;

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
            if (_savedLocations.isEmpty)
              const _NoSavedLocationsWidget()
            else
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
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        locator<SharedPreferencesService>()
                            .deleteSavedLocation(_savedLocations[index]);
                      },
                      child: ListTile(
                        title: Text(
                          location.placeName,
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        onTap: () {
                          widget.onSavedPlaceCallback(
                            location.latitude,
                            location.longitude,
                          );

                          Navigator.pop(context, location);
                        },
                      ),
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

class _NoSavedLocationsWidget extends StatelessWidget {
  const _NoSavedLocationsWidget();

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Icon(
            LineIcons.cloudWithHeavyShowers,
            color: secondaryColor,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            "Oops! You haven't saved any locations yet.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 160,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).colorScheme.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(LineIcons.plus),
                  Text(
                    'Add a location!',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).popAndPushNamed(LocationSearchScreen.id);
              },
            ),
          )
        ],
      ),
    );
  }
}
