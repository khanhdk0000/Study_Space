import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'package:study_space/OutputDevice/controller/buzzer_controller.dart';
import 'package:study_space/OutputDevice/state/buzzer_state.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:math';

final _random = new Random();

class MQTTLightState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";
  double _valueFromServer = 0;
  SensorController sensorController = SensorController();
  MQTTBuzzerState mqttBuzzerState;

  final f = DateFormat('yyyy-MM-dd hh:mm:ss');

  void setReceivedText(String text) async {
    var info = json.decode(text);
    _valueFromServer = double.parse(info['data']);
    print("From server");
    print(_valueFromServer);
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
    await sensorController.addSensorField(
        name: 'LIGHT',
        unit: 'L1',
        type: 'Light',
        timestamp: f.format(DateTime.now()),
        sess_id: '1', // TODO: get current session ID
        data: _valueFromServer.toString());
    if (_valueFromServer > 100) {
      notifyBuzzer();
    }
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  double get getValueFromServer => _valueFromServer;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  void valueFromServer(double d) {
    _valueFromServer = d;
  }

  void setBuzzerState(MQTTBuzzerState state) {
    mqttBuzzerState = state;
    notifyListeners();
  }

  void notifyBuzzer() async {
    MQTTManager manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/buzzer',
        identifier: _random.nextInt(10).toString(),
        state: mqttBuzzerState);
    print('fuck' + mqttBuzzerState.getAppConnectionState.toString());
    manager.initializeMQTTClient();
    await manager.connect();
    Message buzz = Message(id: '1', name: 'buzzer', data: '13', unit: '');
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
