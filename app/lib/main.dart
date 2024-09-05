import 'package:a_strong/app_theme.dart';
import 'package:a_strong/fitness_app/fitness_app_home_screen.dart';
import 'package:a_strong/introduction_animation/introduction_animation_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  String usuario = prefs.getString('Usuario') ?? '';
  bool isLogged = usuario.isNotEmpty;
  runApp(MyApp(
    home: isLogged ? FitnessAppHomeScreen() : const IntroductionAnimationScreen(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.home});
  final Widget? home;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A Strong',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      home: widget.home,
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}