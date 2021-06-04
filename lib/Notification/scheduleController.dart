import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
// import 'package:study_space/Model/user.dart';

class scheduleController {
  Future<String> getDate(int i) async {
    var folder = "get_date.php";
    http.Response response = await http.get(Uri.https(webhost, folder));
    var data = jsonDecode(response.body);
    data[i] = data[i].toString();

    return data[i].substring(19, 23) +
        '-' +
        data[i].substring(13, 15) +
        '-' +
        data[i].substring(16, 18);
  }

  Future<List<String>> getStarttime() async {
    var folder = "get_starttime.php";
    http.Response response = await http.get(Uri.https(webhost, folder));
    var data = jsonDecode(response.body);

    List<String> scheduledStudyList = [];
    for (var i = 0; i < 3; i++) {
      data[i] = await getDate(i) + ' ' + data[i].toString().substring(13, 21);
      scheduledStudyList.add(data[i]);
      print(data[i]);
    }
    return scheduledStudyList;
  }

  Future<List<String>> getEndtime() async {
    var folder = "get_endtime.php";
    http.Response response = await http.get(Uri.https(webhost, folder));
    var data = jsonDecode(response.body);

    List<String> scheduledEndtimeList = [];
    // for (var i = data.length - 3; i < data.length; i++) {
    for (var i = 0; i < 3; i++) {
      data[i] = await getDate(i) + ' ' + data[i].toString().substring(11, 19);
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
