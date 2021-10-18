import 'package:dino_run/screens/main_menu.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'game/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.fullScreen();
  await Flame.util.setLandscape();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dino Run',
        theme: ThemeData(
          fontFamily: 'Audiowide',
          primarySwatch: Colors.blue,
        ),
        home: MainMenu());
  }
}
