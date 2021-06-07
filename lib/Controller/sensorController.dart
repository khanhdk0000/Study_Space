// import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Model/sensor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser;

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
    var session_id = await SessionController().getCurrentSession(user.displayName);
    print('[USERNAME] ${user.displayName}');
    print('[SESSION ID] $session_id');
    var response = await http.post(Uri.https(webhost, 'add_sensor.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'unit': unit,
          'type': type,
          'timestamp': timestamp,
          'sess_id': session_id,
          'data': data
        }));
    print(response.statusCode);

    if (response.statusCode == 201) {
      print('[CONTROLLER] Success');
    } else {
      print('[CONTROLLER] Fail to connect');
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
      int i = 0;
      return (data as List).map((s) {
        i += 1;
        return Sensor.fromJson(s, i);
      }).toList();
    } else {
      print('Failed');
      return null;
    }
  }

  Future<double> getDirectAverage({String sess_id, String type}) async{
    var response = await http.post(Uri.https(webhost, 'get_average_sensor_data.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'session': sess_id,
          'type' : "'" + type + "'",
        }));
    print('[GET DIRECT AVERAGE] ${response.statusCode}');
    print(response.body);
    if (response.statusCode == 201) {
      print("Success");
      if (response.body == ''){
        return -1;
      }
      return double.parse(response.body);
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
    List<String> lightComments = [
      "If the study space is too dark, it will be harmful to your eyes.",
      "Focus learning is good, but don't forget to blink every 5 minutes.",
      "Sometimes when the light from the sun is ok for your study space, you should make use of it."
    ];
    List<String> soundComments = [
      "Do you study and listen to music at the same time?",
      "Remove any distraction around your study space.",
      "Imagine you are learning in the library, the sound intensity of both place should be the same."
    ];
    List<String> tempComments = [
      "A nice weather makes a good study session.",
      "Do you love the weather today? If not, post a Facebook story.",
      "The temperature might not the most weighted factor, but it somehow affect your performance."
    ];
    int rand = Random().nextInt(3);
    if (type == 'Light'){
      return lightComments[rand];
    } else if (type == 'Sound'){
      return soundComments[rand];
    } else if (type == 'Temperature'){
      return tempComments[rand];
    }
  }

  SensorEvaluation getEvaluation(double value, String type){
    if (type == 'Light') {
      if (value >= 400){
        return SensorEvaluation.normal;
      } else if (value >= 300) {
        return SensorEvaluation.warning;
      } else {
        return SensorEvaluation.bad;
      }
    } else if (type == 'Sound') {
      if (value <= 400) {
        return SensorEvaluation.normal;
      } else if (value <= 500) {
        return SensorEvaluation.warning;
      } else {
        return SensorEvaluation.bad;
      }
    } else if (type == 'Temperature') {
      if (value <= 28 && value >= 24){
        return SensorEvaluation.normal;
      } else if (value <= 30 && value >= 22){
        return SensorEvaluation.warning;
      } else {
        return SensorEvaluation.bad;
      }
    }
  }

  String getImage(SensorEvaluation eval){
    if (eval == SensorEvaluation.normal){
      return 'assets/img/haha.png';
    } else if (eval == SensorEvaluation.warning){
      return 'assets/img/sad.png';
    } else {
      return 'assets/img/angry.png';
    }
  }

  String howEvaluatedText(){
    return """
In this version, the performance score is calculated as below:

- Light: The light must be greater 400 unit, otherwise for each 5 unit lower, the performance score is deducted by 1. 
For example: Light = 390 unit, deduct score = (400 - 390) / 5 = 2.

- Sound: The sound must be less than 400 unit, otherwise for each 5 unit greater, the performance score is deducted by 1. 
For example: Sound = 450 unit, deduct score = (450 - 400) / 5 = 10.

- Temperature: The temperature must be in range (24, 28), otherwise for each difference, the performance score is deducted by 8. 
For example: Temperature = 30 degC, deduct score = (30 - 28) * 8 = 16.

The final score will be: 100 - (light penalty + sound penalty + temperature penalty).

We will provide better calculation(s) in later versions, help us with a suggestion by inbox to our application facebook fanpage.""";
  }
}
