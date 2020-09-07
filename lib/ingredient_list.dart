import 'package:flutter/material.dart';
import 'package:tabetai2_flutter/wamp_session.dart';

class IngredientList extends StatefulWidget {
  final WampSession _session;
  List<dynamic> _ingredientData = [];

  IngredientList(this._session) {
    _session.subscribe("com.tabetai2.ingredients", (data) => _update(data));
  }

  void _update(List<dynamic> data) {
    _ingredientData = data;
  }

  @override
  State<StatefulWidget> createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  List<String> _ingredientNames;

  @override
  Widget build(BuildContext context) {
    _ingredientNames = [];
    for (dynamic ingredient in widget._ingredientData) {
      _ingredientNames.add(ingredient[1]);
    }

    if (_ingredientNames.isEmpty) {
      return Text('No ingredients to show');
    }

    return Text('$_ingredientNames');
  }
}
