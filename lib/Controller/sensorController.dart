// import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
import 'package:study_space/Model/sensor.dart';

class SensorController {
  SensorController() {
    print('constructor');
  }
  Future addSensorField(
      {String name,
      String unit,
      String type,
      String timestamp,
      String sess_id,
      String data}) async {
    print('in func');
    var response = await http.post(Uri.https(webhost, 'add_sensor.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'unit': unit,
          'type': type,
          'timestamp': timestamp,
          'sess_id': sess_id,
          'data': data
        }));
    print(response.statusCode);

    if (response.statusCode == 201) {
      print('hell yea');
    } else {
      print('fucking failed');
      return null;
    }
  }

  Future<List<Sensor>> getSensorData({String sess_id, String type}) async {
    var response = await http.post(Uri.https(webhost, 'get_sensor_data.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'session': sess_id,
          'type' : "'" + type + "'",
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Success");
      var data = jsonDecode(response.body);
      return (data as List).map((s) => Sensor.fromJson(s)).toList();
    } else {
      print('Failed');
      return null;
    }
  }

  //Return the average of list of sessions
  double getAverage(List<Sensor> sensorList){
    double sum = 0;
    for(int i = 0; i < sensorList.length; i++){
      sum += sensorList[i].data;
    }
    return (sum / sensorList.length);
  }

  String getReviewText(SensorEvaluation eval, String type){
    String comment;
    if (eval == SensorEvaluation.normal)  comment = "good";
    else if (eval == SensorEvaluation.warning) comment = "not so good";
    else comment = "bad";
    return "The ${type.toLowerCase()} of your study space is $comment";
  }

  String getRandomComment(String type){
    return "Make sure to take a break after 45 minutes of studying.";
  }

  SensorEvaluation getEvaluation(double value, String type){
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
      if (value <= 30 && value >= 25){
        return SensorEvaluation.normal;
      } else if (value <= 33 && value >= 20){
        return SensorEvaluation.warning;
      } else {
        return SensorEvaluation.bad;
      }
    }
  }
}
