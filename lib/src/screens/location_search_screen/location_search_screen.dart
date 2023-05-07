// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sunny_day/constants/keys.dart';
import 'package:sunny_day/src/locator.dart';
import 'package:sunny_day/src/model/saved_location_model.dart';
import 'package:sunny_day/src/services/shared_preferences_service.dart';

class LocationSearchScreen extends StatelessWidget {
  LocationSearchScreen({super.key});

  static const id = 'location_search_screen ';

  final _controller = TextEditingController();

  Future<void> _showSnackbar(
    BuildContext context, {
    required String text,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        closeIconColor: Theme.of(context).colorScheme.secondary,
        duration: const Duration(
          seconds: 2,
        ),
        content: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            LineIcons.arrowLeft,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: GooglePlacesAutoCompleteTextFormField(
                  autofocus: true,
                  enableInteractiveSelection: true,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  inputDecoration: InputDecoration(
                    prefixIcon: Icon(
                      LineIcons.mapAlt,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    hintText: 'search for a city, suburb, or airport!',
                    hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textEditingController: _controller,
                  googleAPIKey: Keys.googlePlacesKey,
                  debounceTime: 400,
                  getPlaceDetailWithLatLng: (prediction) async {
                    if (prediction.lat != null && prediction.lng != null) {
                      final result = await locator<SharedPreferencesService>()
                          .saveLocation(
                        SavedLocation(
                          latitude: double.parse(prediction.lat!),
                          longitude: double.parse(prediction.lng!),
                          placeName: prediction.description!,
                        ),
                      );

                      switch (result) {
                        case SaveNewLocationResponse.success:
                          await _showSnackbar(
                            context,
                            text: 'Location added! 🗺️',
                          );

                          Navigator.of(context).pop();
                          break;
                        case SaveNewLocationResponse.failure:
                          await _showSnackbar(
                            context,
                            text: 'Error saving new location 🛑',
                          );

                          Navigator.of(context).pop();
                          break;
                        case SaveNewLocationResponse.locationAlreadyExists:
                          await _showSnackbar(
                            context,
                            text: 'Location already saved 🛑',
                          );

                          Navigator.of(context).pop();
                          break;
                      }
                    }
                  },
                  itmClick: (prediction) {
                    _controller
                      ..text = prediction.description!
                      ..selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: prediction.description!.length,
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
