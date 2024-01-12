import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(GameWidget(game: LeenaGame()));
}

class LeenaGame extends FlameGame with TapDetector {
  SpriteComponent leena = SpriteComponent();

  double gravity = 1.8;
  double jumpStrength = -100.0; // Adjust the jump strength as needed
  Vector2 velocity = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(SpriteComponent()
      ..sprite = await loadSprite('bg.jpg')
      ..size = size);
    leena
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2.all(150)
      ..position = Vector2(100, 30);
    add(leena);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Always apply gravity:
    velocity.y += gravity;

    leena.position += velocity * dt;
    leena.position.clamp(Vector2.zero(), size - leena.size);
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    if (info.eventPosition.global.x < 100) {
      print("Move Left");
      velocity.x -= 200;
    } else if (info.eventPosition.global.x > size[0] - 100) {
      print("Move Right");
      velocity.x += 200;
    } else {
      // Jump when tapping anywhere else on the screen
      print("Jump");
      velocity.y = jumpStrength;
      // FlameAudio.play('assets/fly.wav');
    }
  }
}
