import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification/time_picker.dart';

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
  DateTime scheduledTime = DateTime.parse("2021-05-14 15:06:00");
  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
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
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   2,
    //   'Break rồiiiiiiiiiiiiiiiiiiiiiiiiiiiiii',
    //   'Giờ chời đến rồi giờ chơi đến rồi, đi chơi thôi',
    //   tz.TZDateTime(tz.local, dateTime.year, dateTime.month, dateTime.hour,
    //       dateTime.minute),
    //   platformChannelSpecifics,
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   payload: 'Ra chơi 15 phút',
    // );
  }

// Method 3
  Future _showStudyNotification(DateTime scheduledTime) async {
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
    await flutterLocalNotificationsPlugin.schedule(
      1,
      'Đi họccccccccccccccccccccc',
      'Êi bạn êi, vô học bạn êi!!',
      scheduledTime,
      platformChannelSpecifics,
      payload: '9h Thứ 3 học Computer Graphic, giờ lo làm homework đi',
    );
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
              new SizedBox(
                height: 30.0,
              ),
              new DateTimeItem(
                  dateTime: scheduledTime,
                  onChanged: (value) {
                    setState(() {
                      scheduledTime = value;
                    });
                  }),
              new ElevatedButton(
                onPressed: () => [
                  _showStudyNotification(scheduledTime),
                  _showBreakNotification(scheduledTime)
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
