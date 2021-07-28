import "package:flutter/cupertino.dart";
import 'package:intl/intl.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/constants.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/Notification/notification_screen.dart';

class TempState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState;
  String _valueFromServer = '0-0';
  double _temperature = 0;
  bool _overThreshold = false;
  SensorController sensorController = SensorController();

  IOWebSocketChannel _subscriptionB;

  TempState() {
    print('Temp state get call');
    _appConnectionState = MQTTAppConnectionState.connected;
    _subscriptionB =
        IOWebSocketChannel.connect(Uri.parse('ws://' + host + '/temp'));
    _subscriptionB.stream.listen((event) async {
      print(event);
      var temp = json.decode(event);

      if (_appConnectionState == MQTTAppConnectionState.connected) {
        valueFromServer(temp['data']);
      }
      _temperature = double.parse(temp['data'].split('-')[0]);

      String sessionId = await getSessionId();
      if (sessionId != '-1') {

        if(_temperature > 30) {
          setBoolThreshold(true);
          print('reeee');
          NotificationScreen initNoti = new NotificationScreen();
          initNoti.tempNoti();
          await notifyBuzzerLcd();

        }
        await pushToDatabase(sessionId);
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
        'data': 'Temp alert',
      }),
    );
    var response2 = await http.post(
      Uri.parse('http://' + host + '/postbuzzer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': '500',
      }),
    );
    print('Status buzzer: ' + response.statusCode.toString());
    print('Status lcd: ' + response2.statusCode.toString());
  }

  Future pushToDatabase(String id) async {
    await sensorController.addSensorField(
        name: 'TEMP-HUMID',
        unit: 'C-%',
        type: 'TH',
        timestamp: f.format(DateTime.now()),
        sessId: id,
        data: _temperature.toString());
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

  String get getValueFromServer => _valueFromServer;
  bool get getOverThreshold => _overThreshold;
  double get getTemperature => _temperature;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  void valueFromServer(String d) {
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
