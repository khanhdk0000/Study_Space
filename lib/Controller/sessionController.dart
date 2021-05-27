import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
import 'dart:convert';
import 'package:study_space/Model/Session.dart';


class SessionController {
  SessionController();

  Future<List<Session>> getAllSessions() async {
    var folder = "get_finished_session.php";
    http.Response response = await http.get(Uri.https(webhost, folder));
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
      return null;
    }
  }
}