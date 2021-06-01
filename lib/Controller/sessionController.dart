import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
import 'dart:convert';
<<<<<<< HEAD
import 'package:study_space/Model/Session.dart';
=======
import 'package:study_space/Model/session.dart';
>>>>>>> main

class SessionController {
  SessionController();

<<<<<<< HEAD
  Future<List<Session>> getAllSessions() async {
    var folder = "get_finished_session.php";
    http.Response response = await http.get(Uri.https(webhost, folder));
=======
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
>>>>>>> main
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
<<<<<<< HEAD
=======

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
>>>>>>> main
}
