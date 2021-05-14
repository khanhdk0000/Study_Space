import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:local_notification/time_picker.dart';

void main() async {
  await _configureLocalTimeZone();

  runApp(
    new MaterialApp(home: new MyApp()),
  );
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  DateTime _selectedTime = new DateTime.now();

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
  Future _showNotificationWithDefaultSound() async {
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
    // var scheduledTime = DateTime.now().add(Duration(seconds: 30));
    var scheduledTime = DateTime.parse("2021-05-14 09:30:00");
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
  Future _showNotificationWithoutSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '2', 'your channel name', 'your channel description',
        playSound: false, importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1,
      'Đi họccccccccccccccccccccc',
      'Êi bạn êi, vô học bạn êi!!',
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
                  dateTime: _selectedTime,
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = value;
                    });
                  }),
              new ElevatedButton(
                onPressed: () => [
                  _showNotificationWithoutSound(),
                  _showNotificationWithDefaultSound()
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

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart';
// import 'package:local_notification/schedule_notifications.dart';
// import 'package:local_notification/time_picker.dart';

// void main() => runApp(new MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   static const _platform = const MethodChannel('schedule_notifications_app');

//   DateTime _selectedTime = new DateTime.now();

//   @override
//   initState() {
//     super.initState();
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       _getIconResourceId();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Plugin example app'),
//         ),
//         body: new Container(
//             child: new Center(
//           child: new Column(children: <Widget>[
//             new DateTimeItem(
//                 dateTime: _selectedTime,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedTime = value;
//                   });
//                 }),
//             new ElevatedButton(
//               child: const Text('SCHEDULE'),
//               onPressed: _scheduleAlarm,
//             ),
//             const SizedBox(height: 20.0),
//             new ElevatedButton(
//               child: const Text('UNSCHEDULE'),
//               onPressed: _unscheduleAlarm,
//             ),
//           ]),
//         )),
//       ),
//     );
//   }

//   Future<dynamic> _getIconResourceId() async {
//     int iconResourceId;
//     try {
//       iconResourceId = await _platform.invokeMethod('getIconResourceId');
//     } on PlatformException catch (e) {
//       print("Error on get icon resource id: x");
//     }

//     setState(() {
//       ScheduleNotifications.setNotificationIcon(iconResourceId);
//     });
//   }

//   void _scheduleAlarm() {
//     // try {
//     //   ScheduleNotifications.schedule("Text", _selectedTime, []);
//     // } on Exception {
//     //   print("Whooops :x");
//     // }
//     // List daysToRepeat = [DateTime.sunday, DateTime.monday];
//     ScheduleNotifications.schedule("Texttttttt", new DateTime.now(), []);
//   }

//   void _unscheduleAlarm() {
//     try {
//       ScheduleNotifications.unschedule();
//     } on Exception {
//       print("Whooops :x");
//     }
//   }
// }
