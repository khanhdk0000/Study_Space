import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/constants.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/Notification/notification_screen.dart';

class LightState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState;
  double _valueFromServer = 0;
  bool _overThreshold = false;
  SensorController sensorController = SensorController();
  IOWebSocketChannel _subscriptionB;

  LightState() {
    print('Light state get call');
    _appConnectionState = MQTTAppConnectionState.connected;
    _subscriptionB =
        IOWebSocketChannel.connect(Uri.parse('ws://' + host + '/light'));

    _subscriptionB.stream.listen((event) async {
      print(event);
      var temp = json.decode(event);
      if (_appConnectionState == MQTTAppConnectionState.connected) {
        valueFromServer(double.parse(temp['data']));
      }

      String sessionId = await getSessionId();
      if (sessionId != '-1') {
        await pushToDatabase(sessionId);
        if(_valueFromServer > 500) {
          setBoolThreshold(true);
          print('reeee');
          // get session id success
          await notifyBuzzerLcd();
          NotificationScreen initNoti = new NotificationScreen();
          initNoti.lightNoti();
        }
      }
    });
  }

  final f = DateFormat('yyyy-MM-dd hh:mm:ss');

  Future notifyBuzzerLcd() async {
    var response = await http.post(
      Uri.parse('http://' + host + '/postlcd'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': 'Light alert',
      }),
    );
    var response2 = await http.post(
      Uri.parse('http://' + host + '/postbuzzer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': '300',
      }),
    );
    print('Status buzzer: ' + response.statusCode.toString());
    print('Status lcd: ' + response2.statusCode.toString());
  }

  Future pushToDatabase(String id) async {
    print("Push light to database");
    await sensorController.addSensorField(
        name: 'LIGHT',
        unit: 'L1',
        type: 'L',
        timestamp: f.format(DateTime.now()),
        sessId: id,
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
