import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';


class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final screen = Screen();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                GameWidget(
                  game: screen,
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Text('Enter!'),
              onPressed: () {
                
              },
            ),
          )
        );
  }
}

class Screen extends FlameGame with HasCollisionDetection {
  Sprite man = Sprite(gender: true);
  final background = Background();
  @override
  Future<void>? onLoad() async {
    await add(background);
    children.register<Sprite>();
    
    super.onLoad();
  }
}

class Sprite extends SpriteComponent with HasGameRef {
  Sprite({
    required this.gender,
  }) : super(size: Vector2.all(100.0));

  bool gender = false;

  @override
  Future<void>? onLoad() async {
    String path = gender ? 'man_character.png' : 'woman_character.png';
    sprite = await gameRef.loadSprite(path);
    position = gameRef.size / 2;
    add(RectangleHitbox());

    return super.onLoad();
  }
}

class Background extends SpriteComponent with HasGameRef {
  @override
  Future<void>? onLoad() async {
    sprite = await gameRef.loadSprite('background.png');
    size = gameRef.size;

    return super.onLoad();
  }
}
