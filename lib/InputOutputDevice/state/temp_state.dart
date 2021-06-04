import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';

class TempState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";
  double _valueFromServer = 0;
  bool _overThreshold = false;
  SensorController sensorController = SensorController();

  final f = DateFormat('yyyy-MM-dd hh:mm:ss');

  void setReceivedText(String text) async {
    var info = json.decode(text);
    // String data = info['data'];
    _valueFromServer = double.parse(info['data'].split('-')[0]);
    print("From server");
    print(_valueFromServer);
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
    await sensorController.addSensorField(
        name: 'TEMP-HUMID',
        unit: 'C-%',
        type: 'TH',
        timestamp: f.format(DateTime.now()),
        sess_id: '1', // TODO: get current session ID
        data: _valueFromServer.toString());
    if (_valueFromServer > 30) {
      _overThreshold = true;
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
  bool get getOverThreshold => _overThreshold;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  void valueFromServer(double d) {
    _valueFromServer = d;
  }

  void setBoolThreshold(bool val) {
    _overThreshold = val;
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
