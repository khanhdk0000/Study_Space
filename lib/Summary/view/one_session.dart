import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/Summary/view/sensor_tile.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Model/sensor.dart';
import 'package:study_space/Summary/view/dialog.dart';

class OneSessionView extends StatefulWidget {
  final List<String> sessionList;
  const OneSessionView({Key key, this.sessionList}) : super(key: key);

  @override
  _OneSessionViewState createState() => _OneSessionViewState();
}

class _OneSessionViewState extends State<OneSessionView> {
  ///List of controllers
  SensorController s = SensorController();

  ///Arguments to handle the sensor data of a session
  Future<List<Sensor>> tempSensorData;
  Future<List<Sensor>> soundSensorData;
  Future<List<Sensor>> lightSensorData;

  ///Arguments to display charts for each component. Default is false.
  bool lightVisible = false;
  bool soundVisible = false;
  bool tempVisible = false;

  @override
  void initState() {
    super.initState();
    print("[DATABASE] Retrieving data");

    ///widget.sessionList[4] means we take the ID of the session recorded in the session list
    tempSensorData = s.getSensorData(sess_id: widget.sessionList[4], type: 'TH');
    soundSensorData = s.getSensorData(sess_id: widget.sessionList[4], type: 'S');
    lightSensorData = s.getSensorData(sess_id: widget.sessionList[4], type: 'L');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
            context: context, builder: (BuildContext context) => FunkyDialog()),
        child: const Icon(Icons.contact_support_outlined, color: Colors.white),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topView(),
            SizedBox(height: kDefaultPadding),
            _sessionView(),
            SizedBox(height: kDefaultPadding),
            _sensorView(),
          ],
        ),
      ),
    );
  }

  Widget _topView() {
    ///The top view include the drawer button and screen name.
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
          child: Row(
            children: [
              MenuButton(),
              Text(
                "      Session Summary",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sessionView() {
    ///Display the information of the session in table format.
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
      child: Column(
        children: [
          _circleScore(widget.sessionList[3]),
          SizedBox(height: kDefaultPadding),
          _tableText("Session Name:", widget.sessionList[1]),
          SizedBox(height: kDefaultPadding * 0.5),
          _tableText("Time:", widget.sessionList[0]),
          SizedBox(height: kDefaultPadding * 0.5),
          _tableText("Date:", widget.sessionList[2]),
        ],
      ),
    );
  }

  Widget _circleScore(String score) {
    String scoreText = (score == '-1') ? 'NA' : score;
    return Container(
        alignment: Alignment.center,
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          color: _circleColor(int.parse(score)),
          shape: BoxShape.circle,
        ),
        child: Text(scoreText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
              color: Colors.white,
            ),),);
  }

  Color _circleColor(int score) {
    if (score >= 90.0) {
      return Colors.greenAccent;
    } else if (score >= 70.0) {
      return Colors.orangeAccent;
    } else if (score > 0) {
      return Colors.redAccent;
    } else {
      return Colors.grey;
    }
  }

  Widget _tableText(String str1, String str2) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 200.0,
          child: Text(
            str1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        Expanded(
          child: Text(
            str2,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sensorView() {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: ListView(
            children: [
              SensorTile(future: lightSensorData, unit: 'Lux', imageAsset: 'assets/img/lightbulb1.png', type: 'Light',),
              SizedBox(height: kDefaultPadding * 0.5),
              SensorTile(future: soundSensorData, unit: 'dB', imageAsset: 'assets/img/stereo.png', type: 'Sound'),
              SizedBox(height: kDefaultPadding * 0.5),
              SensorTile(future: tempSensorData, unit: 'degC', imageAsset: 'assets/img/thermometer.png', type: 'Temperature'),
              SizedBox(height: kDefaultPadding * 2),
            ],
          ),),
    );
  }
}