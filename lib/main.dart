import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:feedback/feedback.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'utils/theme.dart';
import 'screens/tab_screen.dart';
import 'services/ad_manager.dart';
import 'services/feedback_service.dart';
import 'providers/sheet_data_provider.dart';
import 'providers/college_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  _initializeMobileAds();
  runApp(
    BetterFeedback(
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      feedbackBuilder: FeedbackService.builder,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CollegeDataProvider()),
          ChangeNotifierProvider(create: (_) => SheetDataProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

void _initializeMobileAds() async {
  await MobileAds.instance.initialize();
  AdManager().initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JEEBuddy',
      theme: lightMode,
      darkTheme: darkMode,
      home: const TabScreen(),
    );
  }
}
