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

// Method 2
  Future _showBreakNotification(DateTime time) async {
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
    var scheduledTime = time.add(Duration(seconds: 10));
    await flutterLocalNotificationsPlugin.schedule(
      2,
      'Break rồiiiiiiiiiiiiiiiiiiiiiiiiiiiiii',
      'Giờ chời đến rồi giờ chơi đến rồi, đi chơi thôi',
      scheduledTime,
      platformChannelSpecifics,
      payload: 'Ra chơi 15 phút',
    );
  }

  List<String> scheduleList = [
    "2021-05-17 21:29:00",
    "2021-05-17 21:29:30",
    "2021-05-17 21:30:00"
  ];
// Method 3
  Future _showStudyNotification(List<String> scheduleList) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      '2',
      'your channel name',
      'your channel description',
      sound: RawResourceAndroidNotificationSound('mysound'),
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    for (var i = 0; i < 3; i++) {
      print(i);
      await flutterLocalNotificationsPlugin.schedule(
        i,
        'Đi họccccccccccccccccccccc',
        'Êi bạn êi, vô học bạn êi!!',
        DateTime.parse(scheduleList[i]),
        platformChannelSpecifics,
        payload: '9h Thứ 3 học Computer Graphic, giờ lo làm homework đi',
      );
    }
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
              new SizedBox(height: 30.0),
              // new DateTimeItem(
              //     dateTime: DateTime.parse(scheduleList[0]),
              //     onChanged: (value) {
              //       setState(() {
              //         DateTime.parse(scheduleList[0]) = value;
              //       });
              //     }),
              Text(scheduleList[0]),
              new ElevatedButton(
                onPressed: () => [
                  _showStudyNotification(scheduleList),
                  // _showBreakNotification(scheduleList)
                ],
                child: new Text('Study time'),
              ),
              new SizedBox(
                height: 30.0,
              ),
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
