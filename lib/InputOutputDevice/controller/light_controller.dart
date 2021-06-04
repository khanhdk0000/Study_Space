import 'dart:math';
import 'package:study_space/InputOutputDevice/controller/controller.dart';
import 'package:study_space/InputOutputDevice/state/light_state.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'dart:convert';

final _random = new Random();

class LightController extends Controller {
  final LightState lightState;
  MQTTManager manager;

  LightController(this.lightState) {
    manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/light',
        identifier: _random.nextInt(20).toString(),
        state: lightState);
    manager.initializeMQTTClient();
  }

  @override
  void connectAdaServer() async {
    await manager.connect();
  }

  @override
  void disconnectAdaServer() {
    manager.disconnect();
  }

  void publishMessage({String id, String name, String data}) {
    Message light = Message(id: id, name: name, data: data, unit: '');
    String message = jsonEncode(light);
    manager.publish(message);
  }
}

class Message {
  String id;
  String name;
  String data;
  String unit;

  Message({this.id, this.name, this.data, this.unit});

  Map toJson() => {'id': id, 'name': name, 'data': data, 'unit': unit};
}
