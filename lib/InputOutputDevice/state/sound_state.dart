import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/constants.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/Notification/notification_screen.dart';

class SoundState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState;
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

      String sessionId = await getSessionId();
      if (sessionId != '-1') {
        await pushToDatabase(sessionId);
        if (_valueFromServer > 500) {
          print('reeee');
          setBoolThreshold(true);
          // get session id success
          await notifyBuzzerLcd();
          NotificationScreen initNoti = new NotificationScreen();
          initNoti.soundNoti();
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

  Future pushToDatabase(String id) async {
    await sensorController.addSensorField(
        name: 'SOUND',
        unit: '',
        type: 'S',
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
