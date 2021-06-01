import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
<<<<<<< HEAD
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
=======
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Model/sensor.dart';
>>>>>>> main
import 'dart:math' as math;

import 'chart.dart';

class OneSessionView extends StatefulWidget {
  final List<String> sessionList;
  const OneSessionView({Key key, this.sessionList}) : super(key: key);

  @override
  _OneSessionViewState createState() => _OneSessionViewState();
}

class _OneSessionViewState extends State<OneSessionView> {
<<<<<<< HEAD
  final List<String> sensor = ['200', '37', '30'];
  //TODO: Implement a SensorData list for storing data, compute average & evaluate result
=======
  ///Arguments to handle the sensor data of a session
  Future<List<Sensor>> tempSensorData;
  Future<List<Sensor>> soundSensorData;
  Future<List<Sensor>> lightSensorData;

  ///Arguments to display charts for each component. Default is false.
>>>>>>> main
  bool lightVisible = false;
  bool soundVisible = false;
  bool tempVisible = false;

  @override
<<<<<<< HEAD
=======
  void initState() {
    super.initState();
    print("[DATABASE] Retrieving data");
    ///widget.sessionList[4] means we take the ID of the session recorded in the session list
    tempSensorData = SensorController().getSensorData(sess_id: widget.sessionList[4], type: 'TH');
    soundSensorData = SensorController().getSensorData(sess_id: widget.sessionList[4], type: 'S');
    lightSensorData = SensorController().getSensorData(sess_id: widget.sessionList[4], type: 'L');
  }

  @override
>>>>>>> main
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
<<<<<<< HEAD
=======
    ///The top view include the drawer button and screen name.
>>>>>>> main
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
<<<<<<< HEAD
=======
    ///Display the information of the session in table format.
>>>>>>> main
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
<<<<<<< HEAD
=======
    String scoreText = (score == '-99') ? 'NA' : score;
>>>>>>> main
    return Container(
        alignment: Alignment.center,
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          color: _circleColor(int.parse(score)),
          shape: BoxShape.circle,
        ),
        child: Text(
<<<<<<< HEAD
            score,
=======
            scoreText,
>>>>>>> main
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
              color: Colors.white,
            )
        )
    );
  }

<<<<<<< HEAD
  MaterialAccentColor _circleColor(int score){
=======
  Color _circleColor(int score){
>>>>>>> main
    if (score == 100.0){
      return Colors.greenAccent;
    }
    else if (score >= 70.0){
      return Colors.orangeAccent;
    }
<<<<<<< HEAD
    else {
      return Colors.redAccent;
=======
    else if (score > 0){
      return Colors.redAccent;
    } else {
      return Colors.grey;
>>>>>>> main
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
<<<<<<< HEAD
        Text(
          str2,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16.0,
=======
        Expanded(
          child: Text(
            str2,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
            ),
>>>>>>> main
          ),
        ),
      ],
    );
  }

  Widget _sensorView(){
<<<<<<< HEAD
    return Container(
      height: 420.0,
=======
    return Expanded(
>>>>>>> main
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
<<<<<<< HEAD
    String text;
    int value;
    bool visible;
    if (type == 'Light') {
      value = int.parse(sensor[0]);
      text = sensor[0] + ' Lux';
      visible = lightVisible;
    } else if (type == 'Sound') {
      value = int.parse(sensor[1]);
      text = sensor[1] + ' dB';
      visible = soundVisible;
    } else if (type == 'Temperature') {
      value = int.parse(sensor[2]);
      text = sensor[2] + ' degC';
      visible = tempVisible;
    }
    print(type + visible.toString());
=======
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
>>>>>>> main
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        focusColor: Colors.grey,
        onTap: () {
<<<<<<< HEAD
          setState(() {
            if (type == 'Light'){
              lightVisible = !lightVisible;
            } else if (type == 'Sound') {
              soundVisible = !soundVisible;
            } else if (type == 'Temperature') {
              tempVisible = !tempVisible;
            }
          });
=======
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
>>>>>>> main
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
<<<<<<< HEAD
                            'Average: $text',
=======
                            sensorList.length == 0 ? 'No record' : 'Average: $text',
>>>>>>> main
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
<<<<<<< HEAD
                        child: ChartView(),
=======
                        child: ChartView(sensorList: sensorList, type: type),
>>>>>>> main
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

<<<<<<< HEAD
  // This will be moved to SensorData class after built
  SensorEvaluation getEvaluation(int value, String type){
    if (type == 'Light') {
      if (value >= 200){
        return SensorEvaluation.normal;
      } else if (value >= 100) {
        return SensorEvaluation.warning;
      } else {
        return SensorEvaluation.bad;
      }
    } else if (type == 'Sound') {
      if (value <= 50) {
        return SensorEvaluation.normal;
      } else if (value <= 70) {
        return SensorEvaluation.warning;
      } else {
        return SensorEvaluation.bad;
      }
    } else if (type == 'Temperature') {
      if (value <= 32 && value >= 28){
        return SensorEvaluation.normal;
      } else if (value <= 34 && value >= 26){
        return SensorEvaluation.warning;
      } else {
        return SensorEvaluation.bad;
      }
    }
  }

  String getReviewText(SensorEvaluation eval, String type){
    String comment;
    if (eval == SensorEvaluation.normal)  comment = "good";
    else if (eval == SensorEvaluation.warning) comment = "not so good";
    else comment = "bad";
    return "The $type of your study space is $comment";
  }

  String getRandomComment(String type){
    return "Make sure to take a break after 45 minutes of studying.";
  }

  Widget _reviewView(int value, String type){
=======
  Widget _reviewView(double value, String type){
>>>>>>> main
    return Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
<<<<<<< HEAD
            getReviewText(getEvaluation(value, type), type),
=======
            SensorController().getReviewText(SensorController().getEvaluation(value, type), type),
>>>>>>> main
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          Text(
<<<<<<< HEAD
            getRandomComment(type),
=======
            SensorController().getRandomComment(type),
>>>>>>> main
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}

class SensorData {
  int min;
  int val;

  SensorData({this.min, this.val});
}
=======
}
>>>>>>> main
