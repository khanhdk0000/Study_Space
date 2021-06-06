import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:study_space/constants.dart';
import 'dart:convert';
import 'package:study_space/Model/session.dart';
import 'package:study_space/Controller/userController.dart';
import 'sensorController.dart';

class SessionController {
  SessionController();

  Future<List<Session>> getAllSessions(
      int uid, String filter, int limit, String username) async {
    if (uid == null) {
      uid = await userController().getUserId(username);
    }
    print("[CONTROLLER] Getting all sessions.");
    var now = DateTime.now();
    String date = DateFormat('MM/dd/yyyy').format(now);
    var folder = "get_finished_session.php";
    var response =
        await http.post(Uri.https(webhost, 'get_finished_session.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'uid': uid.toString(),
              'filter': filter,
              'limit': limit.toString(),
              'date': date,
            }));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);
      print(data.toString());
      List<Session> sessionLst =
          (data as List).map((s) => Session.fromJson(s)).toList();
      for (int i = 0; i < sessionLst.length; i++) {
        print(sessionLst[i].getScore());
        if (sessionLst[i].getScore() == '0') {
          String score = await this.setScore(sessionLst[i]);
          print(score);
          sessionLst[i].setScore(score);
          //Update the score on the database
          setStatus(sessionLst[i].getId(), score);
        }
      }
      return sessionLst;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data from $folder');
    }
  }

  Future<List<Session>> getUnfinishedSessions(int uid, String filter,
      String maxDate, int limit, String username) async {
    print(uid);
    if (uid == null) {
      uid = await userController().getUserId(username);
    }
    var response =
        await http.post(Uri.https(webhost, 'get_unfinished_sessions.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'user_id': uid.toString(),
              'filter': filter,
              'limit': limit.toString(),
              'max_date': maxDate,
            }));
    print(response.statusCode);
    if (response.statusCode == 200) {
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
    List<String> sortSelection = [
      'Score (H)',
      'Score (L)',
      'Name (A-Z)',
      'Name (Z-A)',
      'Time (H)',
      'Time (L)'
    ];
    if (option == sortSelection[0]) {
      return 'status DESC';
    } else if (option == sortSelection[1]) {
      return 'status';
    } else if (option == sortSelection[2]) {
      return 'title';
    } else if (option == sortSelection[3]) {
      return 'title DESC';
    } else if (option == sortSelection[4]) {
      return 'sessions.date DESC, sessions.start_time DESC';
    } else if (option == sortSelection[5]) {
      return 'sessions.date, sessions.start_time';
    }
  }

  void addSessions(int repeat, int period, String date, String start_time,
      String end_time, String title, int user_id,
      {String username}) async {
    final dateFormat = DateFormat('MM/dd/yyyy');
    final startDate = dateFormat.parse(date);
    if (user_id == null) {
      user_id = await userController().getUserId(username);
    }
    print('[USER ID] $user_id, $username');

    for (var i = 0; i <= repeat; i++) {
      final repeatDate = startDate.add(Duration(days: period * i));

      final dateString = DateFormat('MM/dd/yyyy').format(repeatDate);

      addSession(dateString, start_time, end_time, title, user_id);
    }
  }

  void addSession(String date, String start_time, String end_time, String title,
      int user_id) async {
    var response = await http.post(Uri.https(webhost, 'add_session.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'date': date,
          'start_time': start_time,
          'end_time': end_time,
          'status': "0",
          'title': title,
          'user_id': user_id.toString(),
        }));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      print("Success");
      print(response.body);
    } else {
      print('failed');
    }
  }

  void removeSession(String date, String start_time, String end_time,
      String title, int user_id) async {
    var response = await http.post(Uri.https(webhost, 'remove_session.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'date': date,
          'start_time': start_time,
          'end_time': end_time,
          'status': "0",
          'title': title,
          'user_id': user_id.toString(),
        }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Success");
      print(response.body);
    } else {
      print('Failed');
    }
  }

  Future<String> getCurrentSession(String username) async {
    var con = new userController();
    var curUser = await con.getUser(username);
    var curId = curUser.getId();
    var now = DateTime.now();
    String date = DateFormat('MM/dd/yyyy').format(now);
    String time = DateFormat('kk:mm:ss').format(now);
    print(date);
    print(time);

    var response =
        await http.post(Uri.https(webhost, 'get_current_session.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'user_id': curId.toString(),
              'date': date,
              'time': time,
            }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Success");
      var id = response.body.toString();
      print(id);
      return id;
    } else {
      print('failed');
      return '-1';
    }
  }

  Future<String> setScore(Session s) async {
    //finished sessions but don't have score
    if (int.parse(s.getScore()) == 0) {
      print("[APP] Collecting sensor data");
      int score = 100 +
          await this.getPenaltyLight(s) +
          await this.getPenaltySound(s) +
          await this.getPenaltyTemp(s);
      print("[SESSION SCORE CALCULATED] $score");
      if (score < 0) {
        return "-1";
      } else
        return score.toString();
    } else {
      return s.getScore();
    }
  }

  Future<int> getPenaltyLight(Session s) async {
    double average =
        await SensorController().getDirectAverage(sess_id: s.getId(), type: 'L');
    if (average == null) {
      return -100;
    }
    print('[LIGHT] $average');
    // Light score:
    // >= 400: no penalty
    // < 400: deduct 1 for each 10's less
    // Eg: Light = 320 => (400-320)/5 = 5 (deduct)
    if (average < 400) {
      return (average - 400) ~/ 5;
    } else
      return 0;
  }

  Future<int> getPenaltyTemp(Session s) async {
    double average =
    await SensorController().getDirectAverage(sess_id: s.getId(), type: 'TH');
    if (average == null) {
      return -100;
    }
    print('[TEMPERATURE] $average');
    // Temperature score:
    // In range (24-28): no penalty
    // Out of range: -8 for each difference
    // Eg: Temperature = 29 => (29-28)*8 = 8 (deduct)
    if (average < 24) {
      return ((average - 24) * 8).toInt();
    } else if (average > 28) {
      return ((28 - average) * 8).toInt();
    } else
      return 0;
  }

  Future<int> getPenaltySound(Session s) async {
    double average =
    await SensorController().getDirectAverage(sess_id: s.getId(), type: 'S');
    if (average == null) {
      return -100;
    }
    print('[SOUND] $average');
    // Sound score:
    // Less than 400: no penalty
    // Greater than 400: -1 for each 5's difference
    // Eg: Sound = 500 => (500-400)/5 = 5 (deduct)
    if (average > 400) {
      return (400 - average) ~/ 5;
    } else
      return 0;
  }

  Future<void> setStatus(String id, String status) async {
    print("[CONTROLLER] Setting status.");
    var folder = "get_finished_session.php";
    var response = await http.post(Uri.https(webhost, 'set_status.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': id,
          'status': status,
        }));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data from $folder');
    }
  }
}
