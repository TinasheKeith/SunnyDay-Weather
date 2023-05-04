// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class SunnyDaySearchBar extends StatefulWidget {
  const SunnyDaySearchBar({super.key});

  @override
  _SunnyDaySearchBarState createState() => _SunnyDaySearchBarState();
}

class _SunnyDaySearchBarState extends State<SunnyDaySearchBar> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 40,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _stopSearch,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search location',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
        ],
      ),
    );
  }
}
