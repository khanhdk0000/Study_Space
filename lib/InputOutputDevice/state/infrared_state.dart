import 'package:flutter/cupertino.dart';
import 'package:study_space/constants.dart';

class InfraredState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";

  void setReceivedText(String text) {
    _receivedText = text;
    String inputData = _receivedText.substring(37, 38);
    if (inputData == '0') {
      _historyText = DateTime.now().toString().substring(0, 19) +
          '\nInput data = ' +
          inputData +
          ': Vắng mặt\n' +
          _historyText;
    } else if (inputData == '1') {
      _historyText = 'Input data = ' + inputData + ': Có mặt\n' + _historyText;
    } else {
      _historyText = 'There is no input!\n' + _historyText;
    }
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
