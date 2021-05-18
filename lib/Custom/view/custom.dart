import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/mqtt/state/MQTTAppState.dart';
import 'package:study_space/mqtt/MQTTManager.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

final _random = new Random();

class CustomViewAll extends StatelessWidget {
  const CustomViewAll({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MQTTAppState>(
      create: (_) => MQTTAppState(),
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
  bool _lightStatus = false;

  @override
  void initState() {
    super.initState();
    // if (currentAppState.getAppConnectionState == MQTTAppConnectionState.disconnected){
    //   _configureAndConnect();
    // }
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
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
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
                  _titleWidget('Control Light'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Light',
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
                            _publishMessage(data);
                          });
                        },
                      ),
                    ],
                  ),
                  _titleWidget('Sensor Data'),
                  _sensorValueDisplay('Light', '0'),
                  _sensorValueDisplay('Sound', '0'),
                  _sensorValueDisplay('Temperature', '1'),
                  _titleWidget('History Request'),
                  _buildScrollableTextWith(currentAppState.getHistoryText),
                ],
              ),
            ),
            Spacer(),
            _buildConnectedButtonFrom(currentAppState.getAppConnectionState),
            _connectionStateDisplay(_prepareStateMessageFrom(
                currentAppState.getAppConnectionState)),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget(String name) {
    return Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
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

  Widget _buildConnectedButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          // ignore: deprecated_member_use
          child: RaisedButton(
            color: Colors.lightBlueAccent,
            child: const Text('Connect'),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null, //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          // ignore: deprecated_member_use
          child: RaisedButton(
            color: Colors.redAccent,
            child: const Text('Disconnect'),
            onPressed: state == MQTTAppConnectionState.connected
                ? _disconnect
                : null, //
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
    _getLatestData().then((value) {
      setState(() {
        if (value['data'] == '0') {
          _lightStatus = false;
        } else {
          _lightStatus = true;
        }
      });
    });
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/bbc-led',
        identifier: _random.nextInt(100).toString(),
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
    print("You goes here");
  }

  void _disconnect() {
    manager.disconnect();
  }

  void _publishMessage(String text) {
    Message light = Message(id: '1', name: 'LED', data: text, unit: '');
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
}

class Message {
  String id;
  String name;
  String data;
  String unit;

  Message({this.id, this.name, this.data, this.unit});

  Map toJson() => {'id': id, 'name': name, 'data': data, 'unit': unit};
}
