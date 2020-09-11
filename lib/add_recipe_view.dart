import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddRecipeView extends StatefulWidget {
  List<dynamic> _ingredientData;

  AddRecipeView(this._ingredientData);

  @override
  State<StatefulWidget> createState() => _AddRecipeViewState(_ingredientData);
}

class _AddRecipeViewState extends State<AddRecipeView> {
  List<dynamic> _ingredientData;

  List<String> _availableUnits = ["g", "hg", "kg", "krm", "msk", "ml", "dl", "l", "pcs"];

  int _servings = 4;
  List<String> _steps = [""];
  List<String> _ingredients = [""];
  List<String> _amounts = [""];
  List<String> _units = [""];
  List<String> _availableIngredients = [];

  _AddRecipeViewState(this._ingredientData) {
    for (dynamic ingredient in _ingredientData) {
      _availableIngredients.add(ingredient[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Recipe"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
                      itemCount: _ingredients.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (BuildContext, int index) {
                        return Expanded(child:
                        Row(children: <Widget>[
                          Expanded(child: Text("${_ingredients[index]}")),
                            DropdownButton<String>(
                              items: _availableIngredients.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: _ingredients[index],
                                  child: Text(value),
                                  onTap: () => setState(() => _ingredients[index] = value),
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
                          RaisedButton(onPressed: () => setState(() { _ingredients.add(""); _units.add(""); _amounts.add(""); } )),
                        ]
                        )
                        );
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
            ]),
      ),
    );
  }
}