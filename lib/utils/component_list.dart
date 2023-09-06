import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/player.dart';
import 'package:flutter/cupertino.dart';

import '../sprites/backgrounds.dart';
import '../sprites/draggable.dart';
import '../sprites/enemies.dart';
import '../sprites/walls.dart';
import '../sprites/goal.dart';

class ComponentList {
  List<BasketSprite> _list = [];
  late Player _player;

  ComponentList(List<BasketSprite> initial) : _list = initial;

  void add(BasketSprite comp) {
    _list.add(comp);
  }

  void addAll(List<BasketSprite> compList) {
    _list += compList;
  }

  void remove(BasketSprite comp) {
    _list.remove(comp);
  }

  List<BasketSprite> getList() {
    return _list;
  }

  BasketSprite last() {
    return _list.last;
  }

  Player get getPlayer => _player;

  void clean() {
    _list.clear();
  }

  ComponentList.fromJson(List<dynamic> json, Function showResize, bool isEditor) {
    if (isEditor) {
      for (Map<String, dynamic> entry in json) {
        switch (entry['name']) {
          case 'Wood Wall':
            {
              _list
                  .add(DragWoodWall.fromJson(entry['values'], showResize));
            }
            break;
          case 'Brick Wall':
            {
              _list
                  .add(DragBrickWall.fromJson(entry['values'], showResize));
            }
            break;
          case 'Spike':
            {
              _list.add(DragSpike.fromJson(entry['values'], showResize));
            }
            break;
          case 'Star':
            {
              _list.add(DragStar.fromJson(entry['values'], showResize));
            }
            break;
          case 'Slime':
            {
              _list.add(DragSlime.fromJson(entry['values'], showResize));
            }
            break;
          case 'Trampoline':
            {
              _list.add(DragTrampoline.fromJson(entry['values'], showResize));
            }
            break;
          case 'OneWayPlatform':
            {
              _list.add(DragOneWayPlatform.fromJson(entry['values'], showResize));
            }
            break;
          case 'Arrow':
            {
              _list.add(DragArrow.fromJson(entry['values'], showResize));
            }
            break;
          case 'Goal':
            {
              _list.add(DragBasket.fromJson(entry['values'], showResize));
            }
            break;
          case 'Ball':
            {
              debugPrint('Creating ball from ${entry["values"]}');
              _list.add(DragBall.fromJson(entry['values'], showResize));
              debugPrint('Created ball = ${_list.last.current}');
            }
            break;
          default:
            {
              debugPrint('Entry ${entry["name"]} not recognised');
            }
        }
        debugPrint('$entry');
      }
    } else {
      for (Map<String, dynamic> entry in json) {
        switch (entry['name']) {
          case 'Wood Wall':
            {
              _list
                  .add(WoodWall.fromJson(entry['values']));
            }
            break;
          case 'Brick Wall':
            {
              _list
                  .add(BrickWall.fromJson(entry['values']));
            }
            break;
          case 'Spike':
            {
              _list.add(Spike.fromJson(entry['values']));
            }
            break;
          case 'Star':
            {
              _list.add(Star.fromJson(entry['values']));
            }
            break;
          case 'Slime':
            {
              _list.add(Slime.fromJson(entry['values']));
            }
            break;
          case 'Trampoline':
            {
              _list.add(Trampoline.fromJson(entry['values']));
            }
            break;
          case 'OneWayPlatform':
            {
              _list.add(OneWayPlatform.fromJson(entry['values']));
            }
            break;
          case 'Arrow':
            {
              _list.add(Arrow.fromJson(entry['values']));
            }
            break;
          case 'Goal':
            {
              _list.add(BasketGoal.fromJson(entry['values']));
            }
            break;
          case 'Ball':
            {
              debugPrint('Creating ball from ${entry["values"]}');
              _player = Player.fromJson(entry['values']);
              debugPrint('Created ball = ${_list.last.current}');
            }
            break;
          default:
            {
              debugPrint('Entry ${entry["name"]} not recognised');
            }
        }
        debugPrint('$entry');
      }
    }
  }

  List<Map<String, dynamic>> toJson() {
    debugPrint('Constructing json of list');
    List<Map<String, dynamic>> result = [];
    for (BasketSprite component in _list) {
      result.add({'name': component.getName()});
      result.last['values'] = component.toJson();
    }
    return result;
  }

  @override
  String toString() {
    String result = '';
    for (BasketSprite component in _list) {
      result += '${component.getName()}  ';
    }
    return result;
  }
}
