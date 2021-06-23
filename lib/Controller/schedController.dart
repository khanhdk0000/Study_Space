import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
import 'package:study_space/Model/schedule.dart';

class SchedController {
  SchedController();
  Future<Schedule> addSched(int rep, int period, String date, String startTime,
      String endTime, int userId) async {
    var response = await http.post(Uri.https(webhost, 'add_schedule.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'repetition': rep.toString(),
          'period': period.toString(),
          'date': date,
          'start_time': startTime,
          'end_time': endTime,
          'user_id': userId.toString(),
        }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Success");
      var id = response.body.toString();
      return Schedule(
          int.parse(id), rep, period, date, startTime, endTime, userId);
    } else {
      print('failed');
      return null;
    }
  }

  Future<Schedule> getSched(String username,
      {String sort = 'id', String filter = '*', String limit = '10'}) async {
    var response = await http.post(Uri.https(webhost, 'get_user_schedule.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'sort': sort,
          'filter': filter,
          'limit': limit,
        }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Success");
      var data = jsonDecode(response.body);
      return Schedule.fromJson(data);
    } else {
      print('failed');
      return null;
    }
  }
}
