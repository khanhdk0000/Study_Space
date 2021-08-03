import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Notification/view/setting_switch.dart';
import 'package:study_space/Notification/scheduleController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

bool switchControl = true;
bool breakSwitchControl = true;
bool presenceSwitchControl = true;
bool light = true;
bool sound = true;
bool temp = true;

class NotificationScreen extends StatefulWidget {
  final MyScreen myAppState = new MyScreen();

  @override
  MyScreen createState() => MyScreen();
  void pushNoti() {
    myAppState.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    myAppState._cancelAllNotifications();
    myAppState._pushStudyNotification(
        breakSwitchControl, presenceSwitchControl);
  }

  void lightNoti(String condition) {
    myAppState.initState();
    if (light) {
      myAppState._pushLightNotification(condition);
    }
  }

  void soundNoti() {
    myAppState.initState();
    if (sound) {
      myAppState._pushSoundNotification();
    }
  }

  void tempNoti() {
    myAppState.initState();
    if (temp) {
      myAppState._pushTempNotification();
    }
  }
}

class MyScreen extends State<NotificationScreen> {
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

  ///////////////////////////////////////////////
  // GET STUDY-TIME AND END-TIME FROM DATABASE //
  ///////////////////////////////////////////////
  List<String> scheduledStudyList = [];
  List<String> scheduledEndtimeList = [];
  var c = new scheduleController();

  void clearSchedule() {
    scheduledStudyList.clear();
    scheduledEndtimeList.clear();
  }

  ////////////////////////
  // BREAK NOTIFICATION //
  ////////////////////////
  Future _pushBreakNotification(String time, var i) async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      i,
      'Break time!!!',
      'Take a rest for 15 minutes. Sitting still for too long will cause many diseases.',
      DateTime.parse(time).add(Duration(seconds: 30)),
      platformChannelSpecifics,
      payload: 'Ra chơi 15 phút',
    );
  }

  //////////////////////////////////////
  // START STUDY SESSION NOTIFICATION //
  //////////////////////////////////////
  Future _pushStudyNotification(bool useBreak, bool usePresence) async {
    scheduledStudyList = await c.getStarttime();
    scheduledEndtimeList = await c.getEndtime();
    // print(scheduledStudyList);
    print('Schedule updated successfully!');
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    for (var i = 0; i < scheduledStudyList.length; i++) {
      if (DateTime.parse(scheduledStudyList[i]).isAfter(DateTime.now())) {
        // ignore: deprecated_member_use
        await flutterLocalNotificationsPlugin.schedule(
          i,
          'Study time!!!',
          'Do some exercises now or you will get zero. Good luck, have fun!',
          DateTime.parse(scheduledStudyList[i]),
          platformChannelSpecifics,
          payload: '9h Thứ 3 học Computer Graphic, giờ lo làm homework đi',
        );
        // ignore: deprecated_member_use
        await flutterLocalNotificationsPlugin.schedule(
          i + scheduledStudyList.length * 3,
          'End of session!!!',
          'Awesome! you can stop now. You did really good.',
          DateTime.parse(scheduledEndtimeList[i]),
          platformChannelSpecifics,
          payload: 'Một cái nội dung gì đó về việc tới giờ nghỉ học',
        );
        if (useBreak) {
          _pushBreakNotification(
              scheduledStudyList[i], i + scheduledStudyList.length * 2);
        }
        if (usePresence) {
          void showPresence() {
            _pushPresenceNotification(i + scheduledStudyList.length);
          }

          DateTime time = DateTime.parse(scheduledStudyList[i]).add(Duration(seconds: 60));
          for(;time.isBefore(DateTime.parse(scheduledEndtimeList[i]));) {
            print('alo: ' + time.toString());
            Timer(time.difference(DateTime.now()), showPresence);
            time = time.add(Duration(seconds: 60));
          }
        }
      }
    }
  }

  ////////////////////////////////////
  // PRESENCE DETECT NOTIFICATION ///
  ///////////////////////////////////
  Future _pushPresenceNotification(var i) async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    String last = await _getLatestData3();
    if (last == '0') {
      print('no attended');
      await flutterLocalNotificationsPlugin.schedule(
        i,
        'No attendance!!!',
        'Your child has not sat at his desk yet, you should tell him/her to study now.',
        DateTime.now(),
        platformChannelSpecifics,
        // payload: 'Ra chơi 15 phút',
      );
    }
    else {
      print('attended');
    }
  }

  /////////////////////////////
  // CANCEL ALL NOTIFICATION //
  /////////////////////////////
  _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  ////////////
  // SWITCH //
  ////////////
  void onchange(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        _cancelAllNotifications();
        _pushStudyNotification(breakSwitchControl, presenceSwitchControl);
      });
    } else {
      setState(() {
        switchControl = false;
        breakSwitchControl = false;
        presenceSwitchControl = false;
        _cancelAllNotifications();
        print('cancel successfully!');
      });
    }
  }

  void onchangeBreak(bool value) {
    if (breakSwitchControl == false) {
      setState(() {
        breakSwitchControl = true;
      });
    } else {
      setState(() {
        breakSwitchControl = false;
        for (var i = 0; i < scheduledStudyList.length; i++) {
          flutterLocalNotificationsPlugin
              .cancel(i + scheduledStudyList.length * 2);
        }
      });
    }
    _pushStudyNotification(breakSwitchControl, presenceSwitchControl);
  }

  void onchangePresence(bool value) {
    if (presenceSwitchControl == false) {
      setState(() {
        presenceSwitchControl = true;
      });
    } else {
      setState(() {
        presenceSwitchControl = false;
        for (var i = 0; i < scheduledStudyList.length; i++) {
          flutterLocalNotificationsPlugin
              .cancel(i + scheduledEndtimeList.length);
        }
      });
    }
    _pushStudyNotification(breakSwitchControl, presenceSwitchControl);
  }

  ////////////////////
  // User Interface //
  ////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData(context),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SideMenu(),
        body: ListView(
          children: [
            _topView(),
            StudySwitch(onchange, switchControl),
            PresenceSwitch(onchangePresence, presenceSwitchControl),
            BreakSwitch(onchangeBreak, breakSwitchControl),
            SoundSensorSwitch(sensorSound, sound),
            LightSensorSwitch(sensorLight, light),
            TempSensorSwitch(sensorTemp, temp)
          ],
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

  Future<String> _getLatestData3() async {
    // var req = await http.get(Uri.https('io.adafruit.com', 'api/v2/CSE_BBC1/feeds/bk-iot-infrared/data'));
    var req = await http.get(Uri.https('io.adafruit.com', 'api/v2/khanhdk0000/feeds/infrared-sensor-1/data'));
    var infos = json.decode(req.body);
    var temp1 = infos[0]['value'];
    var temp2 = json.decode(temp1)['data'];
    return temp2.toString();
  }

  Widget _topView() {
    ///The top view include the drawer button and screen name.
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
          child: Row(
            children: [
              MenuButton(),
              Expanded(
                child: Text(
                  "Notification Settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(width: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////////
  // Notification for sensor //
  /////////////////////////////
  Future _pushSoundNotification() async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      -3,
      'Too noisy bro?',
      'Go somewhere else to study đi bro :V',
      DateTime.now(),
      platformChannelSpecifics,
    );
  }

  Future _pushLightNotification(String condition) async {
    String message = condition == 'bright' ? 'Quá sáng' : 'Quá tối';
    String message2 = condition == 'bright'
        ? 'Tắt bớt đèn đi bro'
        : 'Mở đèn lên cho sáng nào';
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      -2,
      message,
      message2,
      DateTime.now(),
      platformChannelSpecifics,
    );
  }

  Future _pushTempNotification() async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      -1,
      'So hot, so humid bro',
      'Bật máy lạnh đi bro',
      DateTime.now(),
      platformChannelSpecifics,
    );
  }

  void sensorSound(bool value) {
    if (sound == false) {
      setState(() {
        sound = true;
      });
    } else {
      setState(() {
        sound = false;
      });
    }
  }

  void sensorLight(bool value) {
    if (light == false) {
      setState(() {
        light = true;
      });
    } else {
      setState(() {
        light = false;
      });
    }
  }

  void sensorTemp(bool value) {
    if (temp == false) {
      setState(() {
        temp = true;
      });
    } else {
      setState(() {
        temp = false;
      });
    }
  }
}
