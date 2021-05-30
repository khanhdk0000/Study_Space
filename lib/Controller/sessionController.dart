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
}
