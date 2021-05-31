import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Model/sensor.dart';
import 'dart:math' as math;

import 'chart.dart';

class OneSessionView extends StatefulWidget {
  final List<String> sessionList;
  const OneSessionView({Key key, this.sessionList}) : super(key: key);

  @override
  _OneSessionViewState createState() => _OneSessionViewState();
}

class _OneSessionViewState extends State<OneSessionView> {
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
    tempSensorData = SensorController().getSensorData(sess_id: widget.sessionList[4], type: 'TH');
    soundSensorData = SensorController().getSensorData(sess_id: widget.sessionList[4], type: 'S');
    lightSensorData = SensorController().getSensorData(sess_id: widget.sessionList[4], type: 'L');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
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

  Widget _topView(){
    ///The top view include the drawer button and screen name.
    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
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

  Widget _sessionView(){
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
    String scoreText = (score == '-99') ? 'NA' : score;
    return Container(
        alignment: Alignment.center,
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          color: _circleColor(int.parse(score)),
          shape: BoxShape.circle,
        ),
        child: Text(
            scoreText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
              color: Colors.white,
            )
        )
    );
  }

  Color _circleColor(int score){
    if (score == 100.0){
      return Colors.greenAccent;
    }
    else if (score >= 70.0){
      return Colors.orangeAccent;
    }
    else if (score > 0){
      return Colors.redAccent;
    } else {
      return Colors.grey;
    }
  }

  Widget _tableText(String str1, String str2){
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

  Widget _sensorView(){
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            children: [
              _sensorTile('Light'),
              SizedBox(height: kDefaultPadding * 0.5),
              _sensorTile('Sound'),
              SizedBox(height: kDefaultPadding * 0.5),
              _sensorTile('Temperature')
            ],
          )
        ),
      ),
    );
  }

  Widget _sensorTile(String type){
    String unit;
    String text;
    double value;
    bool visible;
    Future future;
    if (type == 'Light') {
      unit = 'Lux';
      visible = lightVisible;
      future = lightSensorData;
    } else if (type == 'Sound') {
      unit = 'dB';
      visible = soundVisible;
      future = soundSensorData;
    } else if (type == 'Temperature') {
      unit = 'degC';
      visible = tempVisible;
      future = tempSensorData;
    }
    return FutureBuilder(future: future, builder: (context, snapshot){
      if (snapshot.hasData){
        value = SensorController().getAverage(snapshot.data);
        text = value.toString() + ' ' + unit;
        return _displaySensorTile(type, visible, text, value, snapshot.data);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return Text('Loading...');
    });
  }

  Widget _displaySensorTile(String type, bool visible, String text, double value, List<Sensor> sensorList) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        focusColor: Colors.grey,
        onTap: () {
          if (sensorList.length != 0){
            setState(() {
              if (type == 'Light'){
                lightVisible = !lightVisible;
              } else if (type == 'Sound') {
                soundVisible = !soundVisible;
              } else if (type == 'Temperature') {
                tempVisible = !tempVisible;
              }
            });
          }
        },
        child: Container(
          width: double.infinity,
          height: visible ? 400.0 : 90.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 23,
                spreadRadius: -13,
                color: kShadowColor.withOpacity(0.24),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          type,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                            sensorList.length == 0 ? 'No record' : 'Average: $text',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black54,
                            )
                        )
                      ],
                    ),
                    Transform.rotate(
                      angle: visible ? -math.pi / 2 : math.pi / 2,
                      child: Icon(Icons.chevron_right)
                    ),
                  ],
                ),
                Visibility(
                  visible: visible,
                  child: Column(
                    children: [
                      Container(
                        height: 250.0,
                        child: ChartView(sensorList: sensorList, type: type),
                      ),
                      _reviewView(value, type),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewView(double value, String type){
    return Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            SensorController().getReviewText(SensorController().getEvaluation(value, type), type),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          Text(
            SensorController().getRandomComment(type),
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}