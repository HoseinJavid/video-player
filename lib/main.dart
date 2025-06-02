import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_video_player/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      // systemNavigationBarContrastEnforced: false,
      // systemStatusBarContrastEnforced: false,
    ),
  );

  // // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Video Player',
      home: Home(),
    );
  }
}
