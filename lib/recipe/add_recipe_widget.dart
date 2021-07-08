import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabetai2_flutter/client/wamp/wamp_session.dart';

class AddRecipeView extends StatefulWidget {
  List<dynamic> _ingredientData;
  WampSession _session;

  AddRecipeView(this._ingredientData, this._session);

  @override
  State<StatefulWidget> createState() => _AddRecipeViewState(_ingredientData, _session);
}

class _AddRecipeViewState extends State<AddRecipeView> {
  List<dynamic> _ingredientData;
  WampSession _session;

  List<String> _availableUnits = ["g", "hg", "kg", "krm", "msk", "ml", "dl", "l", "pcs"];
  Map unitMap = {"g": 0, "hg": 1, "kg": 2, "krm": 3, "msk": 4, "ml": 5, "dl": 6, "l": 7, "pcs": 8};

  String _recipeName = "";
  int _servings = 4;
  List<String> _steps = [""];
  List<String> _recipeIngredientNames = [""];
  List<String> _recipeIngredientIds = [""];
  List<String> _amounts = [""];
  List<String> _units = [""];
  List<List<String>> _availableIngredients = [];

  _AddRecipeViewState(this._ingredientData, this._session) {
    for (dynamic ingredient in _ingredientData) {
      _availableIngredients.add([ingredient[0], ingredient[1]]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Recipe"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                onChanged: (value) => _recipeName = value,
                controller: TextEditingController(text: _recipeName),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Enter recipe name'
                ),
              ),
              Container(
                width: 500,
                child:
                Slider(
                  value: _servings.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: "Servings: ${_servings}",
                  onChanged: (double value) {
                    setState(() {
                      _servings = value.round();
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _recipeIngredientNames.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (BuildContext, int index) {
                        return Expanded(child:
                        Row(children: <Widget>[
                          Expanded(child: Text("${_recipeIngredientNames[index]}")),
                            DropdownButton<String>(
                              items: _availableIngredients.map((List<String> value) {
                                return DropdownMenuItem<String>(
                                  value: _recipeIngredientNames[index],
                                  child: Text(value[1]),
                                  onTap: () => setState(() {
                                    _recipeIngredientNames[index] = value[1];
                                    _recipeIngredientIds[index] = value[0];
                                  }),
                                );
                              }).toList(),
                              onChanged: (_) {},
                            ),

                          Expanded(child: TextField(
                            onChanged: (value) => _amounts[index] = value,
                            controller: TextEditingController(text: "${_amounts[index]}"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                hintText: 'Enter amount'
                            ),
                          )),

                          Expanded(child: Text("${_units[index]}")),
                          DropdownButton<String>(
                            items: _availableUnits.map((String entry) {
                              return DropdownMenuItem<String>(
                                value: _units[index],
                                child: Text("$entry"),
                                onTap: () => setState(() => _units[index] = entry),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                          RaisedButton(onPressed: () => setState(() {
                            _recipeIngredientNames.add("");
                            _recipeIngredientIds.add("");
                            _units.add("");
                            _amounts.add("");
                          } )),
                        ]));
                      }).build(context)),
                  Expanded(child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _steps.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (BuildContext, int index) {
                        return Expanded(child:
                          Row(children: <Widget>[
                            Text("${index + 1}. "),
                            Expanded(child: TextField(
                              onChanged: (value) => _steps[index] = value,
                              controller: TextEditingController(text: "${_steps[index]}"),
                              decoration: InputDecoration(
//                                  border: InputBorder,
                                hintText: 'Enter step'
                                ),
                              )),
                            RaisedButton(onPressed: () => setState(() => _steps.add(""))),
                            ]
                          )
                        );
                      }).build(context)),
                ],
              ),
              RaisedButton(onPressed: () => setState(() {
                List<dynamic> args = [];
                args.add(_recipeName);
                args.add(_servings);
                Map ingredients = {};
                for (int i = 0; i < _recipeIngredientIds.length; i++) {
                    ingredients[_recipeIngredientIds[i]] =
                        [int.parse(_amounts[i]), unitMap[_units[i]]];
                }
                args.add(ingredients);
                args.add(_steps);
                _session.call("com.tabetai2.add_recipe", args);
              })),
            ]),
      ),
    );
  }
}