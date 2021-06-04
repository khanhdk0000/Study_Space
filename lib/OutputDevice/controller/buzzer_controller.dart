import 'dart:math';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'package:study_space/OutputDevice/state/buzzer_state.dart';
import 'dart:convert';

import 'package:study_space/constants.dart';

final _random = new Random();

class BuzzerController {
  final MQTTBuzzerState buzzerState;
  MQTTManager manager;

  BuzzerController(this.buzzerState) {
    manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/buzzer',
        identifier: _random.nextInt(10).toString(),
        adaAPIKey: adaPassword,
        adaUserName: adaUserName,
        state: buzzerState);
  }

  void connectAdaServer() async {
    manager.initializeMQTTClient();
    await manager.connect();
  }

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
