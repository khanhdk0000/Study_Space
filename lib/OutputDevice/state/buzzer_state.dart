import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';

class MQTTBuzzerState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";
  double _valueFromServer = 0;

  void setReceivedText(String text) async {
    var info = json.decode(text);
    _valueFromServer = double.parse(info['data']);
    print("From server");
    print(_valueFromServer);
    final f = DateFormat('dd-MM mm:hh');
    _receivedText = info['data'] + 'dB at ' + f.format(DateTime.now());
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
