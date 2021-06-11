import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_space/Notification/view/setting_switch.dart';
import 'package:study_space/Notification/scheduleController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  MyScreen myAppState = new MyScreen();

  @override
  MyScreen createState() => MyScreen();
  void pushNoti() {
    myAppState.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    var androidPlatformChannelSpecifics =
        myAppState.androidPlatformChannelSpecifics;
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    myAppState._cancelAllNotifications();
    myAppState._showStudyNotification(true, false);
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

  var noSound = new AndroidNotificationDetails(
    'id',
    'name',
    'description',
    playSound: false,
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

  Future getNew() async {
    // _showStudyNotification(false, false);
    // _showEndtimeNotification();
    var c = new scheduleController();
    List<String> scheduledStartList = await c.getStarttime();
    List<String> scheduledEndtimeList = await c.getEndtime();
    print(scheduledStartList);
    print(scheduledEndtimeList);
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
    print(scheduledEndtimeList);
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
    // DateTime scheduledTime = DateTime.parse(time).add(Duration(seconds: 10));
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
  bool switchControl = false;
  bool breakSwitchControl = false;
  bool soundSwitchControl = false;
  bool presenceSwitchControl = false;

  void onchange(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        breakSwitchControl = true;
        soundSwitchControl = true;
        _cancelAllNotifications();
        _showStudyNotification(breakSwitchControl, presenceSwitchControl);
      });
    } else {
      setState(() {
        switchControl = false;
        _cancelAllNotifications();
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
  }

  void onchangePresence(bool value) {
    if (presenceSwitchControl == false) {
      setState(() {
        presenceSwitchControl = true;
        _showStudyNotification(breakSwitchControl, presenceSwitchControl);
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
  }

  void onchangeSound(bool value) {
    if (soundSwitchControl == false) {
      setState(() {
        soundSwitchControl = true;
      });
    } else {
      setState(() {
        soundSwitchControl = false;
        _cancelAllNotifications();
        androidPlatformChannelSpecifics = noSound;
        // _showStudyNotification(breakSwitchControl, presenceSwitchControl);
        // _showEndtimeNotification();
      });
    }
  }

  ////////////////////
  // User Interface //
  ////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: kContentColorLightTheme),
          title: Text(
            'Settings',
            style: TextStyle(
              color: kContentColorLightTheme,
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Notification Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
            StudySwitch(onchange, switchControl),
            PresenceSwitch(onchangePresence, presenceSwitchControl),
            BreakSwitch(onchangeBreak, breakSwitchControl),
            SoundSwitch(onchangeSound, soundSwitchControl),
            // SnackBarPage(updateSchedule, clearSchedule),
            // _buildScrollableTextWith(infraredAppState.getHistoryText),
            // SizedBox(
            //   height: 7.0,
            // ),
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
}
