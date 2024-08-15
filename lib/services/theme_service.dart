import 'dart:async';
import 'package:flutter/material.dart';

class ThemeService {
  StreamController<Color> themeStreamController =
      StreamController<Color>.broadcast();
  Stream<Color> getThemeStream() {
    return themeStreamController.stream;
  }

  void setTheme(Color selectedTheme, String stringTheme) {
    themeStreamController.add(selectedTheme);
    debugPrint('Theme: ' + stringTheme);
  }
}
