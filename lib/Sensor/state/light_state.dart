import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'package:study_space/OutputDevice/state/buzzer_state.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';
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
    // TODO: (from khanh) notify buzzer if threshold of light is exceeded,
    // but how to publish message to buzzer feed
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
    // TODO: (from khanh) I create a new manager to publish message, sounds so
    // scam, the page got rebuilt three times, pls check this
    MQTTManager manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/buzzer',
        identifier: _random.nextInt(10).toString(),
        adaAPIKey: adaPassword,
        adaUserName: adaUserName,
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
