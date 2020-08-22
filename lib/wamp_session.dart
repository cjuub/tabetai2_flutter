import 'package:connectanum/connectanum.dart';
import 'package:connectanum/json.dart';

class WampSession {
  Client _client;
  Session _session;

  WampSession(String host) {
    _client = new Client(
        realm: "realm1",
        transport: new WebSocketTransport(
            "ws://" + host + ":9999/ws",
            new Serializer(),
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
}
