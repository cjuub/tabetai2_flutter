import 'package:flutter/material.dart';

class RecipeView extends StatefulWidget {
  dynamic _recipeData;
  List<dynamic> _ingredientData;

  RecipeView(this._recipeData, this._ingredientData);

  @override
  State<StatefulWidget> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  Map unitMap = {0: "g", 1: "hg", 2: "kg", 3: "krm", 4: "msk", 5: "ml", 6: "dl", 7: "l", 8: "pcs"};


  Text _getIngredientEntryText(List<dynamic> ingredientEntry) {
    for (dynamic ingredient in widget._ingredientData) {
      if (ingredient[0] == ingredientEntry[0]) {
        return Text("${ingredientEntry[1][0]} ${unitMap[ingredientEntry[1][1]]}\t${ingredient[1]}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._recipeData[1]),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 500,
                child:
                Slider(
                    value: widget._recipeData[2].toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: "Servings: ${widget._recipeData[2]}",
                    onChanged: (double value) {
                      setState(() {
                        widget._recipeData[2] = value.round();
                      });
                    },
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget._recipeData[3].length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (BuildContext, int index) {
                      return Container(
                        child: _getIngredientEntryText(widget._recipeData[3][index]),
                      );
                    }).build(context)),
                  Expanded(child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget._recipeData[3].length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (BuildContext, int index) {
                        return Container(
                          child: Text("${index + 1}. " + widget._recipeData[4][index]),
                        );
                      }).build(context)),
                ],
              ),
          ]),
        ),
    );
  }
}
