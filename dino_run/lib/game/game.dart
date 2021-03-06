import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DinoGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  Dino _dino;
  ParallaxComponent _parallaxComponent;
  TextComponent _scoreText;
  int score;
  EnemyManager _enemyManager;

  DinoGame() {
    _parallaxComponent = ParallaxComponent(
      [
        ParallaxImage('parallax/plx-1.png'),
        ParallaxImage('parallax/plx-2.png'),
        ParallaxImage('parallax/plx-3.png'),
        ParallaxImage('parallax/plx-4.png'),
        ParallaxImage('parallax/plx-5.png'),
        ParallaxImage('parallax/plx-6.png', fill: LayerFill.none),
      ],
      baseSpeed: Offset(100, 0),
      layerDelta: Offset(20, 0),
    );

    add(_parallaxComponent);

    _dino = Dino();

    add(_dino);

    _enemyManager = EnemyManager();
    add(_enemyManager);

    score = 0;
    _scoreText = TextComponent(score.toString(),
        config: TextConfig(fontFamily: 'Audiowide', color: Colors.white));
    add(_scoreText);
    addWidgetOverlay('Hud', _buildHud());
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _scoreText
        .setByPosition(Position((size.width / 2) - (_scoreText.width / 2), 0));
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    _dino.jump();
  }

  @override
  void update(double t) {
    super.update(t);
    score += (60 * t).toInt();
    _scoreText.text = score.toString();

    components.whereType<Enemy>().forEach((enemy) {
      if (_dino.distance(enemy) < 30) {
        _dino.hit();
      }
    });

    if (_dino.life.value <= 0) {
      gameOver();
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        this.pauseGame();
        break;
      case AppLifecycleState.paused:
        this.pauseGame();
        break;
      case AppLifecycleState.detached:
        this.pauseGame();
        break;
    }
  }

  Widget _buildHud() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: Icon(
              Icons.pause,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              pauseGame();
            }),
        ValueListenableBuilder(
          valueListenable: _dino.life,
          builder: (BuildContext context, value, Widget child) {
            final list = List<Widget>();

            for (int i = 0; i < 5; ++i) {
              list.add(
                Icon(
                  i < value ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              );
            }
            return Row(
              children: list,
            );
          },
        )
      ],
    );
  }

  void pauseGame() {
    pauseEngine();

    addWidgetOverlay('PauseMenu', _buildPauseMenu());
  }

  Widget _buildPauseMenu() {
    return Center(
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Paused',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      resumeGame();
                    })
              ],
            ),
          )),
    );
  }

  void resumeGame() {
    removeWidgetOverlay('PauseMenu');
    resumeEngine();
  }

  void gameOver() {
    pauseEngine();
    addWidgetOverlay('GameOverMenu', _getGameOvermenu());
  }

  Widget _getGameOvermenu() {
    return Center(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 100,
            vertical: 50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GameOver',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Text(
                'Your Score was $score',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: RaisedButton(
                        child: Text(
                          'Retry',
                          style: TextStyle(fontSize: 25),
                        ),
                        onPressed: () {
                          reset();
                          removeWidgetOverlay('GameOverMenu');
                          resumeEngine();
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: RaisedButton(
                        child: Text(
                          'Main Menu',
                          style: TextStyle(fontSize: 25),
                        ),
                        onPressed: () {}),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void reset() {
    this.score = 0;
    _dino.life.value = 5;
    _dino.run();
    _enemyManager.reset();

    components.whereType<Enemy>().forEach((enemy) {
      this.markToRemove(enemy);
    });
  }
}
