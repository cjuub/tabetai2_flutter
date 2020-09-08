import 'package:flutter/material.dart';
import 'package:tabetai2_flutter/recipe_view.dart';
import 'package:tabetai2_flutter/wamp_session.dart';

class RecipeList extends StatefulWidget {
  final WampSession _session;
  List<dynamic> _recipeData = [];

  RecipeList(this._session) {
    _session.subscribe("com.tabetai2.recipes", (data) => _update(data));
  }

  void _update(List<dynamic> data) {
    _recipeData = data;
  }

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
//            onTap: () => print(widget._recipeData[index]),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeView(widget._recipeData[index]))),
            child: Container(
              height: 50,
              child: Center(child: Text('${_recipeNames[index]}')),
            ),
          );
        }).build(context);
  }
}
