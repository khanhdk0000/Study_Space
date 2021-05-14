import 'package:mysql1/mysql1.dart';
import 'dart:async';

import 'package:study_space/constants.dart';
import 'package:study_space/Model/user.dart';
class userController {
  var conn;
  var settings = new ConnectionSettings(
      host: db_host,
      port: db_port,
      user: db_user,
      password: db_password,
      db: db_name
  );
  userController() {print('constructed');}

  Future<String> testSql() async {
    String s = '';
    print('in test');
    var conn  = await MySqlConnection.connect(settings);
    print('con done');
    var results =await conn.query('SELECT * FROM users;');
    for (var row in results) {
      s = s + 'id: ${row[0]}, username: ${row[1]} ';
      print(s);
    }
    await conn.close();
    return s;
  }
}