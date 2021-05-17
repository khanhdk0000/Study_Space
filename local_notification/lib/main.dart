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

  List<String> scheduleList = [
    "2021-05-17 23:47:00",
    "2021-05-18 23:32:30",
    "2021-05-18 23:33:00"
  ];

  // BREAK NOTIFICATION
  Future _showBreakNotification(String time, var i) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      '1',
      'name',
      'description',
      sound: RawResourceAndroidNotificationSound('mysound'),
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );
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

  // STUDY NOTIFICATION
  Future _showStudyNotification(List<String> scheduleList) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      '2',
      'name',
      'description',
      sound: RawResourceAndroidNotificationSound('mysound'),
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    var priority = 0;
    for (var i = 0; i < 3; i++) {
      priority++;
      await flutterLocalNotificationsPlugin.schedule(
        priority,
        'Đi họccccccccccccccccccccc',
        'Êi bạn êi, vô học bạn êi!!',
        DateTime.parse(scheduleList[i]),
        platformChannelSpecifics,
        payload: '9h Thứ 3 học Computer Graphic, giờ lo làm homework đi',
      );
      priority++;
      _showBreakNotification(scheduleList[i], priority);
    }
  }

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
              for (var i in scheduleList) Text(i),
              ElevatedButton(
                onPressed: () => _showStudyNotification(scheduleList),
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
