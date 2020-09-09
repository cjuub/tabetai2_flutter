import 'package:flutter/material.dart';
import 'package:tabetai2_flutter/recipe_view.dart';

class RecipeList extends StatefulWidget {
  List<dynamic> _recipeData;
  List<dynamic> _ingredientData;

  RecipeList(this._recipeData, this._ingredientData);

  @override
  State<StatefulWidget> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<String> _recipeNames;

  @override
  Widget build(BuildContext context) {
    _recipeNames = [];
    for (dynamic recipe in widget._recipeData) {
      _recipeNames.add(recipe[1]);
    }
    
    if (_recipeNames.isEmpty) {
      return Text('No recipes to show');
    }

    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: _recipeNames.length,

        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeView(widget._recipeData[index], widget._ingredientData))),
            child: Container(
              height: 50,
              child: Center(child: Text('${_recipeNames[index]}')),
            ),
          );
        }).build(context);
  }
}
