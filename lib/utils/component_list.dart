import 'package:basket/sprites/basket_sprites.dart';

class ComponentList {
  List<BasketSprite> _list = [];

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

  ComponentList.fromJson(List<Map<String, dynamic>> json) {
    for (Map<String, dynamic> element in json) {
      print(element);
    }
  }

  List<Map<String, dynamic>> toJson() {
    print('Constructing json of list');
    List<Map<String, dynamic>> result = [];
    for (BasketSprite component in _list) {
      result.add({'name': component.getName()});
      result.last['values'] = component.toJson();
    }
    return result;
  }
}