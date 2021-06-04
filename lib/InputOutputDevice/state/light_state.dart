
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/session.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser;


class LightState with ChangeNotifier {
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
    _valueFromServer = double.parse(info['data']);
    print("From server");
    print(_valueFromServer);
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;

    // String sessid = await getSessionId();


    await sensorController.addSensorField(
        name: 'LIGHT',
        unit: 'L1',
        type: 'L',
        timestamp: f.format(DateTime.now()),

        // sess_id: sessid != null ? sessid : '1',
        //TODO: get current session ID
        sess_id: '1',
        data: _valueFromServer.toString());
    // print('\nhella' + sessid + '\n');

    if (_valueFromServer > 100) {
      _overThreshold = true;
    }
    notifyListeners();
  }


  // Future<String> getSessionId() async {
  //   SessionController sessionController = SessionController();
  //   Session session =
  //       await sessionController.getCurrentSession(user.displayName);
  //   return session.getId();
  // }


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
