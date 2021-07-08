import 'package:flutter/material.dart';

class IngredientList extends StatefulWidget {
  List<dynamic> _ingredientData;

  IngredientList(this._ingredientData);

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
