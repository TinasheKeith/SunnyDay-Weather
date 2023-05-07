import 'package:flutter/material.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    this.onSearchFieldTapped,
    super.key,
  });

  final Function? onSearchFieldTapped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.white,
                child: TextField(
                  readOnly: true,
                  onTap: () => onSearchFieldTapped?.call(),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'search for a city, suburb, or airport!',
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
