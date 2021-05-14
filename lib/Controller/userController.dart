import 'package:mysql1/mysql1.dart';
import 'package:study_space/constants.dart';
class UserController {
  Future<MySqlConnection> connect() async{ //connect to db
    var settings = new ConnectionSettings(
        host: db_host,
        port: db_port,
        user: db_user,
        password: db_password,
        db: db_name
    );
    var conn = await MySqlConnection.connect(settings);
    return conn;
  }
  Future<void> disconnect(MySqlConnection conn) async{ //disconnect from db
      await conn.close();
  }
  Future<void> testSql() async {
    var conn = await this.connect();
    var results = await conn.query('SELECT * FROM users');
    for (var row in results) {
      print('id: ${row[0]}, username: ${row[1]} ');
    }
    this.disconnect(conn);
  }
}