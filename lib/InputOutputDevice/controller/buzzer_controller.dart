import 'dart:math';

import 'package:study_space/InputOutputDevice/controller/controller.dart';

import 'package:study_space/InputOutputDevice/state/buzzer_state.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'dart:convert';

final _random = new Random();


class BuzzerController extends Controller {


  final BuzzerState buzzerState;
  MQTTManager manager;

  BuzzerController(this.buzzerState) {
    manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/buzzer',
        identifier: _random.nextInt(20).toString(),
        state: buzzerState);
    manager.initializeMQTTClient();
  }

  @override
  void connectAdaServer() async {
    // manager.initializeMQTTClient();
    await manager.connect();
  }

  @override
  void disconnectAdaServer() {
    manager.disconnect();
  }

  void publishMessage({String id, String name, String data}) {
    Message buzz = Message(id: id, name: name, data: data, unit: '');
    String message = jsonEncode(buzz);
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
