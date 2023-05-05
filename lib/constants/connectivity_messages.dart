// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars, missing_whitespace_between_adjacent_strings, no_adjacent_strings_in_list

import 'dart:math';

class ConnectivityMessages {
  static final List<String> _messages = [
    "No internet connection? Looks like it's time to take up meteorology as a hobby. "
        'No internet? Just look out the window and take a wild guess at the weather!'
        "No signal? Looks like you're on your own, pal."
        'No internet, no problem. Just imagine the weather and go with your gut feeling!'
        'No connection? No worries! Just dress for the weather you want, not the weather you have.'
        'Looks like your internet connection is missing, just like your umbrella.'
        'No internet, no forecasts. Just trust your instincts and embrace the unpredictability of the weather.'
        "No Wi-Fi? No weather updates. It's time to channel your inner weatherman and make your own forecast."
        "No internet connection? Don't worry, the weather won't wait for anyone anyway!"
  ];

  static String getMessage() {
    final _randomPosition = Random().nextInt(_messages.length);
    return _messages[_randomPosition];
  }
}
