import 'dart:convert';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/MQTTServer/state/MQTTAppState.dart';
import 'package:study_space/MQTTServer/state/MQTTSensorState.dart';
import 'package:study_space/MQTTServer/state/MQTTInfraredState.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

final _random = new Random();

class CustomViewAll extends StatelessWidget {
  const CustomViewAll({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MQTTAppState>(create: (_) => MQTTAppState()),
        ChangeNotifierProvider<MQTTSensorState>(
            create: (_) => MQTTSensorState()),
        ChangeNotifierProvider<MQTTInfraredState>(
            create: (_) => MQTTInfraredState()),
      ],
      child: CustomView(),
    );
  }
}

class CustomView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomViewState();
  }
}

class _CustomViewState extends State<CustomView> {
  final TextEditingController _idTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _dataTextController = TextEditingController();
  final TextEditingController _unitTextController = TextEditingController();

  MQTTAppState currentAppState;
  MQTTManager manager;
  MQTTSensorState sensorCurrentAppState;
  MQTTManager sensorManager;
  MQTTInfraredState infraredCurrentAppState;
  MQTTManager infraredManager;
  MQTTManager infraredManager2;
  bool _lightStatus = false;
  bool _overThreshold = false;
  bool _sensorTest = false;
  bool _infraredStatus1 = false;
  bool _infraredStatus2 = false;
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _idTextController.dispose();
    _nameTextController.dispose();
    _dataTextController.dispose();
    _unitTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
    // Change lightStatus display on the application by device current status.
    String recentText = currentAppState.getReceivedText;
    if (recentText != "") {
      print(recentText);
      var message = jsonDecode(recentText);
      String data = message['data'].toString();
      if (data == "0" && _lightStatus) {
        _lightStatus = false;
      } else if (data != "0" && !_lightStatus) {
        _lightStatus = true;
      }
    }
    // Sensor part
    final MQTTSensorState sensorState = Provider.of<MQTTSensorState>(context);
    sensorCurrentAppState = sensorState;
    String sensorText = sensorState.getReceivedText;
    double valueFromServerSensor = sensorState.getValueFromServer;
    if (valueFromServerSensor > 100.00) {
      _overThreshold = true;
    }

    // TODO: (from khanh) How to implement this but different screens?
    if (_overThreshold) {
      _publishMessage(id: '1', name: 'LED', data: '1');
      _overThreshold = false;
      sensorState.valueFromServer(0.0);
      _lightStatus = true;

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Value from server exceeds threshold')));
    }

    // Infrared sensor part
    final MQTTInfraredState infraredState =
        Provider.of<MQTTInfraredState>(context);
    infraredCurrentAppState = infraredState;
    String infraredText = infraredState.getReceivedText;
    if (infraredText != "") {
      var nmessage = jsonDecode(infraredText);
      String ndata = nmessage['data'].toString();
      // if (ndata == "0" && _infraredStatus1) {
      //   _infraredStatus1 = false;
      // } else if (ndata != "0" && !_infraredStatus1) {
      //   _infraredStatus1 = true;
      // }
    }

    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              children: [
                MenuButton(),
                Text(
                  'Customize',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Column(
                children: [
                  _titleWidget('Control Light', 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Led',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      FlutterSwitch(
                        width: 80,
                        height: 40.0,
                        valueFontSize: 13.0,
                        toggleSize: 25.0,
                        value: _lightStatus,
                        borderRadius: 30.0,
                        padding: 8.0,
                        showOnOff: true,
                        onToggle: (value) {
                          setState(() {
                            _lightStatus = value;
                            String data = value ? "2" : "0";
                            _publishMessage(id: '1', name: 'LED', data: data);
                          });
                        },
                      ),
                    ],
                  ),
                  _titleWidget('History Request', 16.0),
                  _buildScrollableTextWith(currentAppState.getHistoryText),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildConnectedButtonFrom(
                      currentAppState.getAppConnectionState,
                      _configureAndConnect,
                      _disconnect),
                  _connectionStateDisplay(_prepareStateMessageFrom(
                      currentAppState.getAppConnectionState)),
                  // This shit is so messy
                  // Sensor
                  Divider(
                    color: Colors.black87,
                  ),
                  _titleWidget('Sensor Data', 25.0),
                  _sensorValueDisplay('Light', 'Threshold: 100'),
                  _buildSlider(sensorCurrentAppState.getAppConnectionState),
                  _titleWidget('History Request', 16.0),
                  _buildScrollableTextWith(
                      sensorCurrentAppState.getHistoryText),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildConnectedButtonFrom(
                      sensorCurrentAppState.getAppConnectionState,
                      _configureAndConnect2,
                      _disconnect2),
                  _connectionStateDisplay(_prepareStateMessageFrom(
                      sensorCurrentAppState.getAppConnectionState)),
                  // Infrared Sensor
                  _titleWidget('Infrared Sensor', 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlutterSwitch(
                        value: _infraredStatus1,
                        showOnOff: true,
                        onToggle: (value) {
                          setState(() {
                            _infraredStatus1 = value;
                            // data1 = value ? '1' : '0';
                          });
                        },
                      ),
                      FlutterSwitch(
                        value: _infraredStatus2,
                        showOnOff: true,
                        onToggle: (value) {
                          setState(() {
                            _infraredStatus2 = value;
                          });
                        },
                      ),
                      ElevatedButton(
                          onPressed: () =>
                              _repeat(_infraredStatus1, _infraredStatus2),
                          child: Text('abc'))
                    ],
                  ),
                  _titleWidget('History Request', 16.0),
                  _buildScrollableTextWith(
                      infraredCurrentAppState.getHistoryText),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildConnectedButtonFrom(
                      infraredCurrentAppState.getAppConnectionState,
                      _configureAndConnect3,
                      _disconnect3),
                  _connectionStateDisplay(_prepareStateMessageFrom(
                      infraredCurrentAppState.getAppConnectionState)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget(String name, double size) {
    return Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }

  Widget _sensorValueDisplay(String name, String val) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              val,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        SizedBox(height: kDefaultPadding),
      ],
    );
  }

  Widget _connectionStateDisplay(String status) {
    Color color;
    if (status == 'Connected') {
      color = Colors.greenAccent;
    } else if (status == 'Disconnected') {
      color = Colors.redAccent;
    } else {
      color = Colors.orangeAccent;
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              color: color,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Text(status, textAlign: TextAlign.center),
              )),
        ),
      ],
    );
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 400,
        height: 200,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildConnectedButtonFrom(
      MQTTAppConnectionState state, Function connect, Function disconnect) {
    return Row(
      children: <Widget>[
        Expanded(
          // ignore: deprecated_member_use
          child: RaisedButton(
            color: Colors.lightBlueAccent,
            child: const Text('Connect'),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? connect
                : null, //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          // ignore: deprecated_member_use
          child: RaisedButton(
              color: Colors.redAccent,
              child: const Text('Disconnect'),
              disabledColor: Colors.grey,
              onPressed: state != MQTTAppConnectionState.disconnected
                  ? () => disconnect()
                  : null //
              ),
        ),
      ],
    );
  }

  // Utility functions
  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
    }
  }

  void _configureAndConnect() {
    // TODO: Use UUID

    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/bbc-led',
        identifier: _random.nextInt(10).toString(),
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
    _getLatestData().then((value) {
      setState(() {
        if (value['data'] == '0') {
          _lightStatus = false;
        } else {
          _lightStatus = true;
        }
      });
    });
    print("You goes here");
  }

  void _disconnect() {
    setState(() {
      _lightStatus = false;
    });
    manager.disconnect();
  }

  void _publishMessage({String id, String name, String data}) {
    Message light = Message(id: id, name: name, data: data, unit: '');
    String message = jsonEncode(light);
    manager.publish(message);
    // _messageTextController.clear();
  }

  _getLatestData() async {
    var req = await http.get(
        Uri.https('io.adafruit.com', 'api/v2/khanhdk0000/feeds/bbc-led/data'));
    var infos = json.decode(req.body);
    print(infos[0]['value']);
    var temp = infos[0]['value'];
    var temp2 = json.decode(temp);
    print(temp2['data'] + '1');
    return temp2;
  }

///////////////////////////
  void _publishMessage2({String id, String name, String data}) {
    Message light = Message(id: id, name: name, data: data, unit: '');
    String message = jsonEncode(light);
    sensorManager.publish(message);
    // _messageTextController.clear();
  }

  void _configureAndConnect2() {
    sensorManager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/sensor',
        identifier: _random.nextInt(10).toString(),
        state: sensorCurrentAppState);
    sensorManager.initializeMQTTClient();
    sensorManager.connect();
  }

  void _disconnect2() {
    sensorManager.disconnect();
  }

  Widget _buildSlider(MQTTAppConnectionState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 19),
            ),
            Text(
              _currentSliderValue.toStringAsFixed(3),
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 19),
            ),
          ],
        ),
        Slider(
          value: _currentSliderValue,
          min: 0,
          max: 100,
          label: _currentSliderValue.round().toString(),
          onChanged: (newValue) {
            setState(() {
              _currentSliderValue = newValue;
            });
          },
          onChangeEnd: (value) {
            if (state == MQTTAppConnectionState.connected) {
              _publishMessage2(
                  id: '2',
                  name: 'Light',
                  data: value.toStringAsFixed(3).toString());
            }
          },
        ),
      ],
    );
  }

  Timer timer;
  void _configureAndConnect3() {
    infraredManager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/welcome-dashboard',
        identifier: _random.nextInt(10).toString(),
        state: infraredCurrentAppState);

    infraredManager.initializeMQTTClient();
    infraredManager.connect();
  }

  void _disconnect3() {
    setState(() {
      _infraredStatus1 = false;
      _infraredStatus2 = false;
    });
    timer?.cancel();
    infraredManager.disconnect();
    infraredManager2.disconnect();
  }

  String _repeat(bool _infraredStatus1, bool _infraredStatus2) {
    timer?.cancel();
    String data1 = _infraredStatus1 ? '1' : '0';
    String data2 = _infraredStatus2 ? '1' : '0';
    String data = data1 + data2;
    timer = Timer.periodic(Duration(seconds: 5),
        (Timer t) => _publishMessage3(id: '16', name: 'INFRARED', data: data));
    return data;
  }

  void _publishMessage3({String id, String name, String data}) {
    Message light = Message(id: id, name: name, data: data, unit: '');
    String message = jsonEncode(light);
    infraredManager.publish(message);
    // _messageTextController.clear();
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
