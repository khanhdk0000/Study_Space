import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
import 'package:study_space/Model/schedule.dart';

class schedController {
  schedController();
  Future<Schedule> addSched
      (int rep , int period , String date, String start_time, String end_time, int user_id) async {
      var response = await http.post(
        Uri.https(webhost,'add_sched.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode( <String, String> {
          'repetition' : rep.toString(),
          'period' : period.toString(),
          'date' : date,
          'start_time' : start_time,
          'end_time' : end_time,
          'user_id' : user_id.toString(),
        })
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("Success");
        var id = response.body.toString();
        return Schedule(int.parse(id), rep, period, date, start_time, end_time, user_id);
      }
      else {
        print('failed');
        return null;
      }
  }
  Future<Schedule> getSched
      (int user_id, {String sort = 'id' , String filter ='*' , String limit = '10'})  async{
      var response = await http.post(
      Uri.https(webhost,'get_sched.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode( <String, String> {
        'user_id' : user_id.toString(),
        'sort' : sort,
        'filter' : filter,
        'limit' : limit,
      })
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("Success");
        var data = jsonDecode(response.body);
        return Schedule.fromJson(data);
      }
      else {
        print('failed');
        return null;
      }
  }

}
