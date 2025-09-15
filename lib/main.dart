import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'main_hub_screen.dart';
import 'services/background_audio_service.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  if (!kIsWeb) {
    await BackgroundAudioService().initializeAndPlay();
  }
  runApp(const DailyQuestApp());
}

class DailyQuestApp extends StatelessWidget {
  const DailyQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routine Helper',
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
      home: const MainHubScreen(),
    );
  }
}
