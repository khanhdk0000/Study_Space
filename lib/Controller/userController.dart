// import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_space/constants.dart';
import 'package:study_space/Model/user.dart';

class userController {
  userController() {
    print('constructed');
  }

  Future<String> testSql() async {
    var folder = "get_session.php";
    http.Response response = await http.get(Uri.https(webhost, folder));
    var data = jsonDecode(response.body);
    print(data.toString());
    return data.toString();
  }

  Future<User> addUser(
      String username, String fname, String lname, String dob) async {
    print('in func');
    var response = await http.post(Uri.https(webhost, 'add_user.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'fname': fname,
          'lname': lname,
          'dob': dob
        }));
    print(response.statusCode);

    if (response.statusCode == 201) {
      print("Success");
      var id = response.body.toString();
      return User(int.parse(id), username, fname, lname, dob);
    } else {
      print('failed');
      return null;
    }
  }

  Future<User> getUser(String username) async {
    var response = await http.post(Uri.https(webhost, 'get_user.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
        }));
    if (response.statusCode == 201) {
      print("Success");
      var data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      print('failed');
      return null;
    }
  }
}
