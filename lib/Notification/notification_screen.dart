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
bool breakSwitchControl = false;
bool presenceSwitchControl = false;
// bool soundSwitchControl = true;
// bool vibrateSwitchControl = true;
bool light = true;
bool sound = true;
bool temp = true;

class NotificationScreen extends StatefulWidget {
  MyScreen myAppState = new MyScreen();

  @override
  MyScreen createState() => MyScreen();
  void pushNoti() {
    myAppState.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    myAppState._cancelAllNotifications();
    myAppState._showStudyNotification(
        breakSwitchControl, presenceSwitchControl);
  }

  void lightNoti() {
    myAppState.initState();
    if (light) {
      myAppState._showLightNotification();
    }
  }

  void soundNoti() {
    myAppState.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    if (sound) {
      myAppState._showSoundNotification();
    }
  }

  void tempNoti() {
    myAppState.initState();
    if (temp) {
      myAppState._showTempNotification();
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
  Future _showBreakNotification(String time, var i) async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      i,
      'Break rồiiiiiiiiiiiiiiiiiiiiiiiiiiiiii',
      'Giờ chời đến rồi giờ chơi đến rồi, đi chơi thôi',
      DateTime.parse(time).add(Duration(seconds: 15)),
      platformChannelSpecifics,
      payload: 'Ra chơi 15 phút',
    );
  }

  //////////////////////////////////////
  // START STUDY SESSION NOTIFICATION //
  //////////////////////////////////////
  Future _showStudyNotification(bool useBreak, bool usePresence) async {
    scheduledStudyList = await c.getStarttime();
    scheduledEndtimeList = await c.getEndtime();
    print(scheduledStudyList);
    print('Schedule updated successfully!');
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    for (var i = 0; i < scheduledStudyList.length; i++) {
      if (DateTime.parse(scheduledStudyList[i]).isAfter(DateTime.now())) {
        await flutterLocalNotificationsPlugin.schedule(
          i,
          'Đi họccccccccccccccccccccc',
          'Êi bạn êi, vô học bạn êi!!',
          DateTime.parse(scheduledStudyList[i]),
          platformChannelSpecifics,
          payload: '9h Thứ 3 học Computer Graphic, giờ lo làm homework đi',
        );
        await flutterLocalNotificationsPlugin.schedule(
          i + scheduledEndtimeList.length * 3,
          'Hết giờ !!!!!!!!!!!!!!!!',
          'Nghỉ đi tan rồi, cố quá là quá cố',
          DateTime.parse(scheduledEndtimeList[i]),
          platformChannelSpecifics,
          payload: 'Một cái nội dung gì đó về việc tới giờ nghỉ học',
        );
        if (useBreak) {
          _showBreakNotification(
              scheduledStudyList[i], i + scheduledStudyList.length * 2);
        }
        if (usePresence) {
          void showPresence() {
            _showPresenceNotification(
                scheduledStudyList[i], i + scheduledEndtimeList.length);
          }

          DateTime time =
              DateTime.parse(scheduledStudyList[i]).add(Duration(seconds: 10));
          Timer(time.difference(DateTime.now()), showPresence);
        }
      }
    }
  }

  ////////////////////////////////////
  // PRESENCE DETECT NOTIFICATION ///
  ///////////////////////////////////
  Future _showPresenceNotification(String time, var i) async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    String last = await _getLatestData3();
    if (last == '0') {
      await flutterLocalNotificationsPlugin.schedule(
        i,
        'Vắng mặt',
        'Tới giờ rồi mà chưa vô vậy bro',
        DateTime.now(),
        platformChannelSpecifics,
        // payload: 'Ra chơi 15 phút',
      );
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
        _showStudyNotification(breakSwitchControl, presenceSwitchControl);
      });
    } else {
      setState(() {
        switchControl = false;
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
    _showStudyNotification(breakSwitchControl, presenceSwitchControl);
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
    _showStudyNotification(breakSwitchControl, presenceSwitchControl);
  }

  // void onchangeSound(bool value) {
  //   if (soundSwitchControl == false) {
  //     setState(() {
  //       soundSwitchControl = true;
  //     });
  //   } else {
  //     setState(() {
  //       soundSwitchControl = false;
  //       _cancelAllNotifications();
  //       _showStudyNotification(breakSwitchControl, presenceSwitchControl);
  //     });
  //   }
  // }

  // void onchangeVibrate(bool value) {
  //   if (vibrateSwitchControl == false) {
  //     setState(() {
  //       vibrateSwitchControl = true;
  //     });
  //   } else {
  //     setState(() {
  //       vibrateSwitchControl = false;
  //       _cancelAllNotifications();
  //       _showStudyNotification(breakSwitchControl, presenceSwitchControl);
  //     });
  //   }
  // }

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
          // padding: const EdgeInsets.all(20),
          children: [
            _topView(),
            StudySwitch(onchange, switchControl),
            PresenceSwitch(onchangePresence, presenceSwitchControl),
            BreakSwitch(onchangeBreak, breakSwitchControl),
            // SoundSwitch(onchangeSound, soundSwitchControl),
            // VibrateSwitch(onchangeVibrate, vibrateSwitchControl),
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
    var req = await http.get(Uri.https(
        'io.adafruit.com', 'api/v2/khanhdk0000/feeds/infrared-sensor-1/data'));
    var infos = json.decode(req.body);
    var temp = infos[0]['value'];
    var temp2 = json.decode(temp)['data'];
    return temp2.toString();
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 400,
        height: 200,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
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
  Future _showSoundNotification() async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      -3,
      'Too noisy bro?',
      'Go somewhere else to study đi bro :V',
      DateTime.now(),
      platformChannelSpecifics,
      // payload: 'Ra chơi 15 phút',
    );
  }

  Future _showLightNotification() async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      -2,
      'Too sáng bro',
      'Tắt bớt đèn đi bro',
      DateTime.now(),
      platformChannelSpecifics,
      // payload: 'Ra chơi 15 phút',
    );
  }

  Future _showTempNotification() async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      -1,
      'So hot, so humid bro',
      'Bật máy lạnh đi bro',
      DateTime.now(),
      platformChannelSpecifics,
      // payload: 'Ra chơi 15 phút',
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
