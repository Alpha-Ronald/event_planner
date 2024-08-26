import 'package:event_planner_app/core/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lightMode);

  void toggleTheme() {
    if (state.brightness == Brightness.dark) {
      state = lightMode;
    } else {
      state = darkMode;
    }
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) => ThemeNotifier(),
);
