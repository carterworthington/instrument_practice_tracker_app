import 'package:flutter/material.dart';
import 'package:instrument_practice_tracker/routes.dart' as routes;
import 'package:instrument_practice_tracker/pages/home_screen.dart';
import 'package:instrument_practice_tracker/pages/history_screen.dart';
import 'package:instrument_practice_tracker/pages/log_session_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instrument_practice_tracker/theme/theme.dart';  

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,     // <-- APPLY THE THEME
      initialRoute: routes.homeRoute,
      routes: {
        routes.homeRoute: (context) => HomePage(),
        routes.logRoute: (context) => LogPage(),
        routes.historyRoute: (context) => HistoryPage(),
      },
    );
  }
}
