// import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:study_space/Authentication/screen/welcome_screen.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Model/user.dart';
import 'package:flutter/material.dart';

import 'package:study_space/global.dart';

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

  Future<User> addUser(String username,
      {String fname = '', String lname = '', String dob = ''}) async {
    print('add user');
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
    print("get user");
    var response = await http.post(Uri.https(webhost, 'get_user.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
        }));
    print(response.statusCode);
    if ((response.statusCode == 201) && (response.body.isNotEmpty)) {
      print("Success");
      var data = jsonDecode(response.body);
      print(data);
      return User(int.parse(data[0]), data[1], data[2], data[3], data[4]);
    } else {
      print('failed');
      return null;
    }
  }

  Future<int> getUserId(String username, BuildContext context) async {
    print('get user id');
    var u = await getUser(username);
    if (u != null) {
      userId = u.getId();
      return u.getId();
    } else {
      print("User error");
      checkId(context);
      return -1;
    }
  }

  void popup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildPopupDialog(context),
    );
  }

  void reroute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Oops'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Something went wrong.\nPlease login again."),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            // reroute(context);
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }

  String getCharacterName() {
    List<String> characterNames = [
      "Captain America",
      "Iron Man",
      "Thor Odinson",
      "Hulk",
      "Black Widow",
      "Hawkeye",
      "War Machine",
      "Vision",
      "Scarlet Witch",
      "Falcon",
      "Spider-Man",
      "Ant-Man",
      "Nebula",
      "Batman"
    ];
    int rand = Random().nextInt(characterNames.length);
    return characterNames[rand];
  }
}
