import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class BuzzerState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState;
  String _historyText = "";

  IOWebSocketChannel _subscriptionB;

  BuzzerState() {
    print('Buzzer state get call');
    _appConnectionState = MQTTAppConnectionState.connected;
    _subscriptionB =
        IOWebSocketChannel.connect(Uri.parse('ws://10.0.2.2:5000/buzzer'));
    _subscriptionB.stream.listen((event) async {
      print(event);
      var temp = json.decode(event);
      setHistoryText(temp['data']);
    });
  }

  void setHistoryText(String text) async {
    final f = DateFormat('dd-MM hh:mm');
    _historyText =
        _historyText + '\n' + text + ' dB at ' + f.format(DateTime.now());
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get getHistoryText => _historyText;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  void disposeStream() {
    _subscriptionB.sink.close();
  }
}
