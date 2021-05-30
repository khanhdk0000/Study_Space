// import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
import 'package:study_space/Model/user.dart';

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

  // Future<User> getUser(String username) async {
  //   var response = await http.post(Uri.https(webhost, 'get_user.php'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'username': username,
  //       }));
  //   if (response.statusCode == 201) {
  //     print("Success");
  //     var data = jsonDecode(response.body);
  //     return User.fromJson(data);
  //   } else {
  //     print('failed');
  //     return null;
  //   }
  // }
}
