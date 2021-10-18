import 'dart:ui';
import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/time.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';

class Dino extends AnimationComponent {
  Animation _runAnimation;
  Animation _hitAnimation;
  Timer _timer;
  bool isHit;

  double speedY = 0.0;
  double yMax = 0.0;

  ValueNotifier<int> life;

  Dino() : super.empty() {
    // ideal 0-4
    //run 4-10
    //kick 11-13
    //hit 14-16
    //sprint 17-23

    final spriteSheet = SpriteSheet(
      imageName: 'DinoSprites - tard.png',
      textureWidth: 24,
      textureHeight: 24,
      columns: 24,
      rows: 1,
    );

    _runAnimation =
        spriteSheet.createAnimation(0, from: 4, to: 10, stepTime: 0.1);
    _hitAnimation =
        spriteSheet.createAnimation(0, from: 14, to: 16, stepTime: 0.1);
    this.animation = _runAnimation;

    _timer = Timer(1, callback: () {
      run();
    });

    isHit = false;

    this.anchor = Anchor.center;

    life = ValueNotifier(5);
  }
  @override
  void resize(Size size) {
    super.resize(size);

    this.height = this.width = size.width / numberofTilesAlongWidth;
    this.x = this.width;

    this.y =
        size.height - groundHeight - (this.height / 2) + dinoTopBottomSpacing;
    this.yMax = this.y;
  }

  @override
  void update(double t) {
    super.update(t);
    //v = u + a*t
    this.speedY += GRAVITY * t;
    //d=s0+s*t
    this.y += this.speedY * t;

    if (isonGround()) {
      this.y = this.yMax;
      this.speedY = 0.0;
    }

    _timer.update(t);
  }

  bool isonGround() {
    return (this.y >= this.yMax);
  }

  void run() {
    isHit = false;
    this.animation = _runAnimation;
  }

  void hit() {
    if (!isHit) {
      isHit = true;
      this.animation = _hitAnimation;
      life.value -= 1;
      _timer.start();
    }
  }

  void jump() {
    if (isonGround()) {
      this.speedY = -500;
    }
  }
}
