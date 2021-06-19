import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/constants.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SoundState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState;
  String _historyText = "";
  double _valueFromServer = 0;
  bool _overThreshold = false;
  SensorController sensorController = SensorController();

  IOWebSocketChannel _subscriptionB;

  SoundState() {
    print('Sound state get call');
    _appConnectionState = MQTTAppConnectionState.connected;
    _subscriptionB =
        IOWebSocketChannel.connect(Uri.parse('ws://' + host + '/sound'));
    _subscriptionB.stream.listen((event) async {
      print(event);
      var temp = json.decode(event);
      if (_appConnectionState == MQTTAppConnectionState.connected) {
        valueFromServer(double.parse(temp['data']));
      }

      if (_valueFromServer > 500) {
        print('reeee');
        setBoolThreshold(true);
        var response = await http.post(
          Uri.parse('http://' + host + '/postlcd'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'data': 'Sound alert',
          }),
        );
        var response2 = await http.post(
          Uri.parse('http://' + host + '/postbuzzer'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'data': '400',
          }),
        );
        print('Status: ' + response.statusCode.toString());
        print('Status 2: ' + response2.statusCode.toString());
      }
      pushToDatabase();
    });
  }

  final f = DateFormat('yyyy-MM-dd hh:mm:ss');

  void pushToDatabase() async {
    String sessid = await getSessionId();
    await sensorController.addSensorField(
        name: 'SOUND',
        unit: '',
        type: 'S',
        timestamp: f.format(DateTime.now()),
        sess_id: sessid,
        data: _valueFromServer.toString());
  }

  Future<String> getSessionId() async {
    SessionController sessionController = SessionController();
    String session =
        await sessionController.getCurrentSession(user.displayName);
    return session;
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get getHistoryText => _historyText;
  double get getValueFromServer => _valueFromServer;
  bool get getOverThreshold => _overThreshold;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  void valueFromServer(double d) {
    _valueFromServer = d;
    notifyListeners();
  }

  void setBoolThreshold(bool val) {
    _overThreshold = val;
    notifyListeners();
  }

  void disposeStream() {
    _subscriptionB.sink.close();
  }
}
