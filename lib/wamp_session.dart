import 'package:connectanum/connectanum.dart';
import 'package:connectanum/json.dart';

class WampSession {
  Client _client;
  Session _session;

  WampSession(String host) {
    _client = Client(
        realm: "realm1",
        transport: WebSocketTransport(
            "ws://" + host + ":9999/ws",
            Serializer(),
            WebSocketSerialization.SERIALIZATION_JSON
        )
    );
  }

  Future<void> connect() async {
    _session = await _client.connect().first;
  }

  Future<Subscribed> subscribe(String topic, Function callback) async {
    var subscription = await _session.subscribe(topic);
    subscription.eventStream.listen((event) => callback(event.arguments));
    return subscription;
  }

  void call(String topic, List<dynamic> args) async {
    _session.call(topic, arguments: args).listen((ev) => print(ev.arguments[0]),
        onError: (e) {var error = e as Error; print(error.error); });
  }
}
