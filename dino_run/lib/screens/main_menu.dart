import 'package:dino_run/screens/game_play.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Card(
            color: Colors.black.withOpacity(0.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Dino Runn',
                    style: TextStyle(fontSize: 60, color: Colors.white),
                  ),
                  RaisedButton(
                      child: Text(
                        'Play',
                        style: TextStyle(fontSize: 25),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => GamePlay(),
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
