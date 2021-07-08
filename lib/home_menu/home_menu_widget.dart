import 'package:tabetai2_flutter/client/wamp/wamp_session.dart';
import 'package:tabetai2_flutter/ingredient/ingredient_list_widget.dart';
import 'package:tabetai2_flutter/recipe/add_recipe_widget.dart';
import 'package:tabetai2_flutter/recipe/recipe_list_widget.dart';

import 'package:flutter/material.dart';

class HomeMenuWidget extends StatefulWidget {
  HomeMenuWidget({Key key, this.title, this.session}) : super(key: key);

  final String title;
  final WampSession session;

  @override
  _HomeMenuWidgetState createState() => _HomeMenuWidgetState(session);
}

class _HomeMenuWidgetState extends State<HomeMenuWidget> {
  final WampSession _session;
  int _currentIndex = 0;

  Widget _scheduleView;
  RecipeList _recipeListView;
  IngredientList _ingredientListView;

  List<dynamic> _ingredientData = [];
  List<dynamic> _recipeData = [];

  Widget _currentView;

  _HomeMenuWidgetState(this._session) {
    _scheduleView = Text("No schedule view yet!");
    _recipeListView = RecipeList([], []);
    _ingredientListView = IngredientList([]);

    _currentView = _scheduleView;

    _subscribeToTopics();
  }

  void _subscribeToTopics() {
    _session.subscribe("com.tabetai2.recipes",
            (data) => setState(() => _recipeData = data));
    _session.subscribe("com.tabetai2.ingredients",
            (data) => setState(() => _ingredientData = data));
  }

  void _selectView(int value) {
    _currentIndex = value;

    if (_currentIndex == 0) {
      _currentView = _scheduleView;
    } else if (_currentIndex == 1) {
      _currentView = _recipeListView;
    } else if (_currentIndex == 2) {
      _currentView = _ingredientListView;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    _scheduleView = Text('No schedule view yet!');
    _ingredientListView = IngredientList(_ingredientData);
    _recipeListView = RecipeList(_recipeData, _ingredientData);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_currentView],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddRecipeView(_ingredientData, _session))),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.onSurface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          setState(() => _selectView(value));
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Schedule'),
            icon: Icon(Icons.date_range),
          ),
          BottomNavigationBarItem(
            title: Text('Recipes'),
            icon: Icon(Icons.restaurant_menu),
          ),
          BottomNavigationBarItem(
            title: Text('Ingredients'),
            icon: Icon(Icons.shopping_basket),
          ),
        ],
      ),
    );
  }
}
