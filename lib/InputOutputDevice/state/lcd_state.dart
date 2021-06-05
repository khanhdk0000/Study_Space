import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';

class LCDState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";
  String _valueFromServer = '';

  void setReceivedText(String text) async {
    var info = json.decode(text);
    _valueFromServer = info['data'].toString();
    print("From server");
    print(_valueFromServer);
    final f = DateFormat('dd-MM hh:mm');
    _receivedText = _valueFromServer + ' ' + f.format(DateTime.now());
    _historyText = _historyText + '\n' + _receivedText;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  String get getValueFromServer => _valueFromServer;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  // void valueFromServer(double d) {
  //   _valueFromServer = d;
  // }
}
