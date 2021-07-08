import 'package:tabetai2_flutter/client/wamp/wamp_session.dart';
import 'package:tabetai2_flutter/home_menu/home_menu_widget.dart';

import 'package:flutter/material.dart';

void main() async {
  var session = WampSession("localhost");
  await session.connect();

  runApp(Tabetai2Client(session));
}

class Tabetai2Client extends StatelessWidget {
  final WampSession _session;

  Tabetai2Client(this._session);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabetai2 Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeMenuWidget(title: 'Tabetai2 Client', session: _session),
    );
  }
}

