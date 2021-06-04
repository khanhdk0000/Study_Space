import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_space/Notification/scheduleController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:study_space/MQTTServer/state/MQTTInfraredState.dart';
// import 'package:study_space/MQTTServer/MQTTManager.dart';
// import 'package:provider/provider.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';

class NotificationScreen extends StatefulWidget {
  @override
  MyScreen createState() => MyScreen();
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
  Future updateSchedule() async {
    var c = new scheduleController();
    clearSchedule();
    scheduledStudyList = await c.getStarttime();
    scheduledEndtimeList = await c.getEndtime();
  }

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

  //////////////////////////////////////
  // START STUDY SESSION NOTIFICATION //
  //////////////////////////////////////
  Future _showStudyNotification(
      List<String> scheduledStudyList, bool useBreak) async {
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
        if (useBreak) {
          priority++;
          _showBreakNotification(scheduledStudyList[i], priority);
        }
      }
    }
  }

  ////////////////////////////////////
  // END STUDY SESSION NOTIFICATION //
  ////////////////////////////////////
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

  /////////////////////////////
  // CANCEL ALL NOTIFICATION //
  /////////////////////////////
  Future _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  ////////////
  // SWITCH //
  ////////////
  bool switchControl = false;
  bool breakSwitchControl = false;

  void onchange(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        breakSwitchControl = true;
        _cancelAllNotifications();
        _showStudyNotification(scheduledStudyList, true);
        _showEndtimeNotification(scheduledEndtimeList);
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
        _cancelAllNotifications();
        _showStudyNotification(scheduledStudyList, false);
        _showEndtimeNotification(scheduledEndtimeList);
      });
    }
  }

  bool presenceSwitchControl = false;
  void onchangePresence(bool value) {
    if (presenceSwitchControl == false) {
      setState(() {
        presenceSwitchControl = true;
      });
    } else {
      setState(() {
        presenceSwitchControl = false;
      });
    }
  }

  ////////////////////
  // User Interface //
  ////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            StudySwitch(onchange, switchControl),
            PresenceSwitch(onchangePresence, presenceSwitchControl),
            BreakSwitch(onchangeBreak, breakSwitchControl),
            SnackBarPage(updateSchedule, clearSchedule),
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
}

class StudySwitch extends StatelessWidget {
  final Function onchange;
  final bool switchControl;
  StudySwitch(this.onchange, this.switchControl);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Allow Study Notification"),
        Switch(
          value: switchControl,
          onChanged: (bool value) => onchange(value),
          activeColor: kPrimaryColor,
        ),
      ],
    );
  }
}

class PresenceSwitch extends StatelessWidget {
  final Function onchangePresence;
  final bool presenceSwitchControl;
  PresenceSwitch(this.onchangePresence, this.presenceSwitchControl);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Allow Presence Notification"),
        Switch(
          value: presenceSwitchControl,
          onChanged: (bool value) => onchangePresence(value),
          activeColor: kPrimaryColor,
        ),
      ],
    );
  }
}

class BreakSwitch extends StatelessWidget {
  final Function onchangeBreak;
  final bool breakSwitchControl;
  BreakSwitch(this.onchangeBreak, this.breakSwitchControl);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Allow Break Notification"),
        Switch(
          value: breakSwitchControl,
          onChanged: (bool value) => onchangeBreak(value),
          activeColor: kPrimaryColor,
        ),
      ],
    );
  }
}

class SnackBarPage extends StatelessWidget {
  final Function updateSchedule;
  final Function clearSchedule;
  SnackBarPage(this.updateSchedule, this.clearSchedule);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await updateSchedule();
          final snackBar = SnackBar(
            content: Text('Updated Successfully!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                clearSchedule();
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Text('Update schedule',
            style: TextStyle(color: kContentColorLightTheme)),
        style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
        ),
      ),
    );
  }
}
