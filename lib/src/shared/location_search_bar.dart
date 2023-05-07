import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                LineIcons.mapAlt,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Material(
                child: TextField(
                  readOnly: true,
                  onTap: () => onSearchFieldTapped?.call(),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Search for city',
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
