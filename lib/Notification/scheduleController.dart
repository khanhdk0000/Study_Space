import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
import 'package:study_space/global.dart';

class scheduleController {
  Future<List<String>> getStarttime() async {
    var folder = "get_starttime.php";
    var response = await http.post(Uri.https(webhost, folder),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId.toString(),
        }));
    var data = json.decode(response.body);
    List<String> scheduledStudyList = [];
    for (var i = 0; i < data.length; i++) {
      String date = data[i]['date'];
      data[i] = date.substring(6, 10) +
          '-' +
          date.substring(0, 2) +
          '-' +
          date.substring(3, 5) +
          ' ' +
          data[i]['start_time'];
      scheduledStudyList.add(data[i]);
    }
    return scheduledStudyList;
  }

  Future<List<String>> getEndtime() async {
    var folder = "get_endtime.php";
    var response = await http.post(Uri.https(webhost, folder),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId.toString(),
        }));
    var data = jsonDecode(response.body);

    List<String> scheduledEndtimeList = [];
    for (var i = 0; i < data.length; i++) {
      String date = data[i]['date'];
      data[i] = date.substring(6, 10) +
          '-' +
          date.substring(0, 2) +
          '-' +
          date.substring(3, 5) +
          ' ' +
          data[i]['end_time'];
      scheduledEndtimeList.add(data[i]);
    }
    return scheduledEndtimeList;
  }

  Future<int> getLength() async {
    var folder = "get_schedule.php";
    http.Response response = await http.get(Uri.https(webhost, folder));
    var data = jsonDecode(response.body);
    return data.length;
  }
}
