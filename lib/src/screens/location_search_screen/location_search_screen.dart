import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sunny_day/constants/keys.dart';

class LocationSearchScreen extends StatelessWidget {
  LocationSearchScreen({super.key});

  static const id = 'location_search_screen ';

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            LineIcons.arrowLeft,
            color: Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).canvasColor,
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
                  inputDecoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'search for a city, suburb, or airport!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textEditingController: _controller,
                  googleAPIKey: Keys.googlePlacesKey,
                  debounceTime: 400,
                  getPlaceDetailWithLatLng: (prediction) {},
                  itmClick: (prediction) {
                    _controller
                      ..text = prediction.description!
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
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
