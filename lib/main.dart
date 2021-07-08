import 'package:tabetai2_flutter/ingredient/ingredient_list.dart';
import 'package:tabetai2_flutter/recipe/add_recipe_view.dart';
import 'package:tabetai2_flutter/recipe/recipe_list.dart';
import 'package:tabetai2_flutter/client/wamp/wamp_session.dart';

import 'package:flutter/material.dart';



void main() async {
  var session = WampSession("localhost");
  await session.connect();

  runApp(MyApp(session));
}

class MyApp extends StatelessWidget {
  final WampSession _session;

  MyApp(this._session);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tabetai2 client',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'tabetai2 client', session: _session),
    );
  }
}

class HomePage extends StatefulWidget {
  final WampSession session;

  HomePage({Key key, this.title, this.session}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState(session);
}

class _HomePageState extends State<HomePage> {
  final WampSession _session;
  int _currentIndex = 0;

  Widget _scheduleView;
  RecipeList _recipeListView;
  IngredientList _ingredientListView;

  List<dynamic> _ingredientData = [];
  List<dynamic> _recipeData = [];

  Widget _currentView;

  _HomePageState(this._session) {
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

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    _scheduleView = Text('No schedule view yet!');
    _ingredientListView = IngredientList(_ingredientData);
    _recipeListView = RecipeList(_recipeData, _ingredientData);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_currentView],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddRecipeView(_ingredientData, _session))),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.onSurface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          // Respond to item press.
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
