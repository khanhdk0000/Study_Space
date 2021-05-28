import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:study_space/constants.dart';
// import 'package:study_space/Model/user.dart';

const webhost = "dirtyg.000webhostapp.com";

class scheduleController {
  Future<List<String>> getScheduletime() async {
    var folder = "get_schedule.php";
    http.Response response = await http.get(Uri.https(webhost, folder));
    var data = jsonDecode(response.body);

    List<String> scheduledStudyList = [];
    for (var i = 0; i < data.length; i++) {
      data[i] = data[i].toString().substring(16, 35);
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
    for (var i = 0; i < data.length; i++) {
      data[i] = data[i].toString().substring(11, 30);
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
