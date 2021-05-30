import "package:flutter/cupertino.dart";
import 'package:study_space/constants.dart';
import 'dart:convert';

class MQTTSensorState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";
  double _valueFromServer = 0;

  void setReceivedText(String text) {
    var info = json.decode(text);
    _valueFromServer = double.parse(info['data']);
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
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
