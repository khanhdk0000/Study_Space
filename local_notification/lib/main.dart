import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(
    new MaterialApp(home: new MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettings =
        new InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'id',
    'name',
    'description',
    sound: RawResourceAndroidNotificationSound('mysound'),
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
  );

  List<String> scheduledStudyList = [
    "2021-05-18 11:45:00",
    "2021-05-18 11:46:00",
    "2021-05-18 10:50:30"
  ];

  List<String> scheduledEndtimeList = [
    "2021-05-18 11:45:30",
    "2021-05-18 11:46:30",
    "2021-05-18 10:45:30"
  ];

  // BREAK NOTIFICATION
  Future _showBreakNotification(String time, var i) async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    var scheduledTime = DateTime.parse(time).add(Duration(seconds: 10));
    await flutterLocalNotificationsPlugin.schedule(
      i,
      'Break rồiiiiiiiiiiiiiiiiiiiiiiiiiiiiii',
      'Giờ chời đến rồi giờ chơi đến rồi, đi chơi thôi',
      scheduledTime,
      platformChannelSpecifics,
      payload: 'Ra chơi 15 phút',
    );
  }

  // START STUDY SESSION NOTIFICATION
  Future _showStudyNotification(List<String> scheduledStudyList) async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    var priority = 0;
    for (var i = 0; i < scheduledStudyList.length; i++) {
      if (DateTime.parse(scheduledStudyList[i]).isAfter(DateTime.now())) {
        priority++;
        await flutterLocalNotificationsPlugin.schedule(
          priority,
          'Đi họccccccccccccccccccccc',
          'Êi bạn êi, vô học bạn êi!!',
          DateTime.parse(scheduledStudyList[i]),
          platformChannelSpecifics,
          payload: '9h Thứ 3 học Computer Graphic, giờ lo làm homework đi',
        );
        priority++;
        _showBreakNotification(scheduledStudyList[i], priority);
      }
    }
  }

  // END STUDY SESSION NOTIFICATION
  Future _showEndtimeNotification(List<String> scheduledEndtimeList) async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    for (var i = 0; i < scheduledEndtimeList.length; i++) {
      if (DateTime.parse(scheduledEndtimeList[i]).isAfter(DateTime.now())) {
        await flutterLocalNotificationsPlugin.schedule(
          i + scheduledEndtimeList.length * 2,
          'Hết giờ !!!!!!!!!!!!!!!!',
          'Nghỉ đi tan rồi, cố quá là quá cố',
          DateTime.parse(scheduledEndtimeList[i]),
          platformChannelSpecifics,
          payload: 'Một cái nội dung gì đó về việc tới giờ nghỉ học',
        );
      }
    }
  }

  // CANCEL ALL NOTIFICATION
  Future _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              for (var i in scheduledStudyList) Text(i),
              ElevatedButton(
                onPressed: () => [
                  _showStudyNotification(scheduledStudyList),
                  _showEndtimeNotification(scheduledEndtimeList)
                ],
                child: Text('Turn on notifications'),
              ),
              ElevatedButton(
                  onPressed: _cancelAllNotifications,
                  child: Text('Turn off notifications'))
            ],
          ),
        ),
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Thông báo"),
          content: Text("Nội dung : $payload"),
        );
      },
    );
  }
}
