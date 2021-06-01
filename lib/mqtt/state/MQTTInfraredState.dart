import 'package:flutter/cupertino.dart';
import 'package:study_space/constants.dart';

class MQTTInfraredState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";

  void setReceivedText(String text) {
    _receivedText = text;
    _historyText =
        DateTime.now().toString() + ':' + _receivedText + '\n' + _historyText;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}

class MQTTInfraredState2 with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";

  void setReceivedText(String text) {
    _receivedText = text;
    _historyText =
        DateTime.now().toString() + ':' + _receivedText + '\n' + _historyText;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}
