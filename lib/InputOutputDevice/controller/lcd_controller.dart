import 'dart:math';
import 'package:study_space/InputOutputDevice/controller/controller.dart';
import 'package:study_space/InputOutputDevice/state/lcd_state.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'dart:convert';
import 'package:study_space/constants.dart';

final _random = new Random();

class LCDController extends Controller {
  final LCDState lcdState;
  MQTTManager manager;

  LCDController(this.lcdState) {
    manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: adaTopicLCD,
        identifier: _random.nextInt(20).toString(),
        adaAPIKey: adaPassword,
        adaUserName: adaUserName,
        state: lcdState);
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
