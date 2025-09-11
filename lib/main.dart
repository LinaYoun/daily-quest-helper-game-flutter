import 'package:flutter/material.dart';
import 'constants.dart';
import 'home_screen.dart';

void main() {
  runApp(const DailyQuestApp());
}

class DailyQuestApp extends StatelessWidget {
  const DailyQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Quest Helper',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: colorBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorAccent,
          primary: colorAccent,
          secondary: colorPaper,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: colorText)),
      ),
      home: const HomeScreen(),
    );
  }
}
