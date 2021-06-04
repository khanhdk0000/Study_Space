import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';
import 'package:study_space/Model/session.dart';

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

  Future<List<Session>> getUnfinishedSessions(int userId, String filter, String maxDate, int limit) async {
    var response = await http.post(Uri.https(webhost, 'get_unfinished_sessions.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId.toString(),
          'filter': filter,
          'limit': limit.toString(),
          'max_date': maxDate,
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);
      return (data as List).map((s) => Session.fromJson(s)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("failed");
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

  void addSessions (int repeat , int period , String date, String start_time, String end_time, String title, int user_id) async {
    final dateFormat = DateFormat('MM/dd/yyyy');
    final startDate = dateFormat.parse(date);

    for(var i = 0; i <= repeat; i++){
      final repeatDate = startDate.add(Duration(days: period * i));

      final dateString = DateFormat('MM/dd/yyyy').format(repeatDate);

      addSession(dateString, start_time, end_time, title, user_id);
    }
  }

  void addSession (String date, String start_time, String end_time, String title, int user_id) async {
    var response = await http.post(
        Uri.https(webhost,'add_session.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode( <String, String> {
          'date' : date,
          'start_time' : start_time,
          'end_time' : end_time,
          'status' : "0",
          'title' : title,
          'user_id' : user_id.toString(),
        })
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Success");
      print(response.body);
    }
    else {
      print('failed');
    }
  }

  void removeSession (String date, String start_time, String end_time, String title, int user_id) async {
    var response = await http.post(
        Uri.https(webhost,'remove_session.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode( <String, String> {
          'date' : date,
          'start_time' : start_time,
          'end_time' : end_time,
          'status' : "0",
          'title' : title,
          'user_id' : user_id.toString(),
        })
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Success");
      print(response.body);
    }
    else {
      print('failed');
    }
  }
}
