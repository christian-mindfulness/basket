

import 'dart:ui';

import 'package:basket/sprites/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class BasketBall extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {

  BasketBall({super.children});
  // final World _world = World();
  // LevelManager levelManager = LevelManager();
  // GameManager gameManager = GameManager();
  // int screenBufferSpace = 300;
  // ObjectManager objectManager = ObjectManager();
  // PositionMarker marker = PositionMarker();
  // bool makePause = false;

  final Player _player = Player();
  // Add a Player to the game: Create a Player variable
  //  late Player player;

  @override
  Future<void> onLoad() async {
    // await add(_world);
    // await add(gameManager);
    // overlays.add('gameOverlay');
    // await add(levelManager);
    await add(ScreenHitbox());
    add(_player);
  }

  // @override
  // void update(double dt) {
  //   super.update(dt);
  //   if (gameManager.isGameOver) {
  //     return;
  //   }
  //
  //   if (gameManager.isIntro) {
  //     overlays.add('mainMenuOverlay');
  //     return;
  //   }
  //
  //   if (gameManager.isPlaying) {
  //     checkLevelUp();
  //
  //     final Rect worldBounds = Rect.fromLTRB(0, camera.position.y - screenBufferSpace,
  //         camera.gameSize.x, camera.position.y + _world.size.y);
  //     camera.worldBounds = worldBounds;
  //
  //     if (player.isMovingDown) {
  //       camera.worldBounds = worldBounds;
  //     }
  //
  //     // var isInTopHalfOfScreen = player.position.y <= (_world.size.y / 2);
  //     // if (!player.isMovingDown && isInTopHalfOfScreen) {
  //     //   camera.followComponent(player);
  //     // }
  //
  //     if (player.position.y >
  //         camera.position.y +
  //             _world.size.y -
  //             3*player.size.y +
  //             screenBufferSpace) {
  //       print('${player.position.y}  ${camera.position.y}  ${_world.size.y}  ${player.size.y}  $screenBufferSpace');
  //       player.position.y = camera.position.y +_world.size.y - 3*player.size.y + screenBufferSpace;
  //       player.jump(specialJumpSpeed: 0.9 * player.getVerticalVelocity().abs());
  //     }
  //   }
  //   if (makePause) {
  //     togglePauseState();
  //     makePause = false;
  //   }
  // }
  //
  // @override
  // Color backgroundColor() {
  //   return const Color.fromARGB(255, 241, 247, 249);
  // }
  //
  // void initializeGameStart() {
  //   // Add a Player to the game: Call setCharacter
  //   setCharacter();
  //
  //   gameManager.reset();
  //
  //   if (children.contains(objectManager)) objectManager.removeFromParent();
  //
  //   levelManager.reset();
  //
  //   player.reset();
  //   camera.worldBounds = Rect.fromLTRB(
  //     0,
  //     -_world.size.y,
  //     camera.gameSize.x,
  //     _world.size.y +
  //         screenBufferSpace,
  //   );
  //   //camera.followComponent(player);
  //
  //   player.resetPosition();
  //
  //   // Add a Player to the game: Reset Dash's position back to the start
  //
  //   objectManager = ObjectManager(
  //       minVerticalDistanceToNextPlatform: levelManager.minDistance,
  //       maxVerticalDistanceToNextPlatform: levelManager.maxDistance);
  //
  //   add(objectManager);
  //
  //   objectManager.configure(levelManager.level, levelManager.difficulty);
  // }
  //
  // void setCharacter() {
  //   // Add a Player to the game: Initialize character
  //   player = Player(character: gameManager.character, jumpSpeed: levelManager.startingJumpSpeed);
  //   // Add a Player to the game: Add player
  //   add(player);
  // }
  //
  // void startGame() {
  //   initializeGameStart();
  //   gameManager.state = GameState.playing;
  //   overlays.remove('mainMenuOverlay');
  // }
  //
  // void mainMenu() {
  //   overlays.remove('gameOverOverlay');
  //   overlays.add('mainMenuOverlay');
  // }
  //
  // void onLose() {
  //   gameManager.state = GameState.gameOver;
  //   player.removeFromParent();
  //   overlays.add('gameOverOverlay');
  // }
  //
  // void resetGame() {
  //   startGame();
  //   overlays.remove('gameOverOverlay');
  // }
  //
  // void togglePauseState() {
  //   if (paused) {
  //     resumeEngine();
  //   } else {
  //     pauseEngine();
  //   }
  // }
  //
  // void checkLevelUp() {
  //   if (levelManager.shouldLevelUp(gameManager.score.value)) {
  //     levelManager.increaseLevel();
  //
  //     objectManager.configure(levelManager.level, levelManager.difficulty);
  //
  //     player.setJumpSpeed(levelManager.jumpSpeed);
  //   }
  // }
}