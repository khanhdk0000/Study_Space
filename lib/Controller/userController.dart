import 'package:mysql1/mysql1.dart';
import 'dart:async';

import 'package:study_space/constants.dart';
import 'package:study_space/Model/user.dart';

class userController {
  var settings = new ConnectionSettings(
      host: db_host,
      port: db_port,
      user: db_user,
      password: db_password,
      db: db_name
  );
  userController() {print('constructed');}

  Future<String> testSql() async {
    var conn = await MySqlConnection.connect(settings);
    print('connected');
    //  var result = await conn.query("INSERT INTO `study_space`.`users` (`id`, `username`, `fname`, `lname`, `dob`) VALUES ('13', 'abc', 'b', 'c', '1');");
    // print("insert");
    var results = await conn.query("UPDATE `study_space`.`users` SET `lname` = 'Mohana' WHERE (`id` = '13');");
    // var r = await conn.query("SELECT * FROM `study_space`.`users`;");
    // print(r);
    // for (var row in r) {
    //   print("A");
    //   print('Name: ${row[0]}');
    // }
    await conn.close();
    print("done");
    return "DONE";
  }
}