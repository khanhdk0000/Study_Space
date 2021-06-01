import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';
import 'package:study_space/Model/session.dart';
import 'package:study_space/Controller/userController.dart';
import 'package:study_space/Model/user.dart';

class SessionController {
  SessionController();

  Future<List<Session>> getAllSessions(int uid, String filter, int limit) async {
    var folder = "get_finished_session.php";
    var response = await http.post(Uri.https(webhost, 'get_finished_session.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'uid': uid.toString(),
          'filter': filter,
          'limit': limit.toString(),
        }));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);
      return (data as List).map((s) => Session.fromJson(s)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data from $folder');
    }
  }

  Future<Session> addSession(int sched_id, String date, String start_time,
      String end_time, String status, String title) async {

    var response = await http.post(
        Uri.https(webhost,'add_session.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode( <String, String> {
          'sched_id' : sched_id.toString(),
          'date' : date,
          'start_time' : start_time,
          'end_time' : end_time,
          'status' : status,
          'title' : title,
        })
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Success");
      var id = response.body.toString();
      return Session(id: id, sched_id: sched_id.toString(), date: date, start_time: start_time, end_time: end_time, status: status, title: title);
    }
    else {
      print('failed');
      print(response.body);
      return null;
    }
  }
  String setFilter(String option) {
    List<String> sortSelection = ['Score (H)', 'Score (L)', 'Name (A-Z)', 'Name (Z-A)', 'Time (H)', 'Time (L)'];
    if (option == sortSelection[0]){
      return 'status DESC';
    } else if (option == sortSelection[1]){
      return 'status';
    } else if (option == sortSelection[2]){
      return 'title';
    } else if (option == sortSelection[3]){
      return 'title DESC';
    } else if (option == sortSelection[4]){
      return 'sessions.date DESC, sessions.start_time DESC';
    } else if (option == sortSelection[5]){
      return 'sessions.date, sessions.start_time';
    }
  }

  Future<Session> getCurrentSession(String username) async{
      var con = new userController();
      var curUser = await con.getUser(username);
      var curId = curUser.getId();
      var now = DateTime.now();
      String date = DateFormat('dd/MM/yyyy').format(now);
      String time = DateFormat('kk:mm:ss').format(now);
      print(date);
      print(time);

      var response = await http.post(
          Uri.https(webhost,'get_current_session.php'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode( <String, String> {
              'user_id': curId.toString(),
              'date' : date,
              'time' : time,
          })
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("Success");
        var data = jsonDecode(response.body);
        print(data);
        return Session(id:data[0],sched_id: data[1], date: data[2], start_time: data[3], end_time: data[4],status: data[5],title: data[6]);
      }
      else {
        print('failed');
        return null;
      }

  }
}
