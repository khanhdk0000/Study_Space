import "package:flutter/cupertino.dart";
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';

class MQTTLightState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";
  double _valueFromServer = 0;
  SensorController sensorController = SensorController();

  void setReceivedText(String text) async {
    var info = json.decode(text);
    _valueFromServer = double.parse(info['data']);
    print("From server");
    print(_valueFromServer);
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
    await sensorController.addSensorField(
        name: 'Light',
        unit: 'L1',
        type: 'L',
        timestamp: '2021-01-01 17:00:56',
        sess_id: '1',
        data: _valueFromServer.toString());
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
}
