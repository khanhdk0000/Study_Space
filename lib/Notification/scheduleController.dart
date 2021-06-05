import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
import 'package:study_space/Controller/userController.dart';

class scheduleController {
  Future<String> getDate(int i, String username) async {
    var folder = "get_date.php";
    var uid = await userController().getUserId(username);

    var response = await http.post(Uri.https(webhost, folder),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': uid.toString(),
        }));
    var data = jsonDecode(response.body);
    data[i] = data[i].toString();
    return data[i].substring(13, 17) +
        '-' +
        data[i].substring(7, 9) +
        '-' +
        data[i].substring(10, 12);
  }

  Future<List<String>> getStarttime(String username) async {
    var folder = "get_starttime.php";
    var uid = await userController().getUserId(username);
    var response = await http.post(Uri.https(webhost, folder),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': uid.toString(),
        }));
    var data = jsonDecode(response.body);

    List<String> scheduledStudyList = [];
    for (var i = 0; i < data.length; i++) {
      data[i] = await getDate(i, username) +
          ' ' +
          data[i].toString().substring(13, 21);
      scheduledStudyList.add(data[i]);
      print(data[i]);
    }
    return scheduledStudyList;
  }

  Future<List<String>> getEndtime(String username) async {
    var folder = "get_endtime.php";
    var uid = await userController().getUserId(username);
    var response = await http.post(Uri.https(webhost, folder),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': uid.toString(),
        }));
    var data = jsonDecode(response.body);

    List<String> scheduledEndtimeList = [];
    for (var i = 0; i < data.length; i++) {
      data[i] = await getDate(i, username) +
          ' ' +
          data[i].toString().substring(11, 19);
      scheduledEndtimeList.add(data[i]);
      print(data[i]);
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
