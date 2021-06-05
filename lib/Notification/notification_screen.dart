import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_space/Notification/view/setting_switch.dart';
import 'package:study_space/Notification/scheduleController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:study_space/InputOutputDevice/state/infrared_state.dart';
import 'package:study_space/InputOutputDevice/controller/infrared_controller.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'package:provider/provider.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:math';

final _random = new Random();
final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser;

class NotificationScreen extends StatefulWidget {
  @override
  MyScreen createState() => MyScreen();
}

class MyScreen extends State<NotificationScreen> {
  InfraredController infraredController;
  InfraredState infraredAppState;
  MQTTManager infraredManager;

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
  Future updateSchedule() async {
    var c = new scheduleController();
    clearSchedule();
    scheduledStudyList = await c.getStarttime(user.displayName);
    scheduledEndtimeList = await c.getEndtime(user.displayName);
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

  ////////////////////////////////////
  // PRESENCE DETECT NOTIFICATION //
  ////////////////////////////////////
  Future _showPresenceNotification() async {
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    var scheduledTime = DateTime.now();
    await flutterLocalNotificationsPlugin.schedule(
      1,
      'Vắng mặt',
      'Tới giờ rồi mà chưa vô vậy bro',
      scheduledTime,
      platformChannelSpecifics,
      // payload: 'Ra chơi 15 phút',
    );
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
  bool soundSwitchControl = false;

  void onchange(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        breakSwitchControl = true;
        soundSwitchControl = true;
        _cancelAllNotifications();
        _showStudyNotification(scheduledStudyList, breakSwitchControl);
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
        _showStudyNotification(scheduledStudyList, breakSwitchControl);
        _showEndtimeNotification(scheduledEndtimeList);
      });
    }
  }

  bool presenceSwitchControl = false;
  void onchangePresence(bool value, MQTTAppConnectionState state,
      Function connect, Function disconnect) {
    if (presenceSwitchControl == false) {
      setState(() {
        presenceSwitchControl = true;
        connect();
      });
    } else {
      setState(() {
        presenceSwitchControl = false;
        disconnect();
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
        _showStudyNotification(scheduledStudyList, breakSwitchControl);
        _showEndtimeNotification(scheduledEndtimeList);
      });
    }
  }

  ////////////////////
  // User Interface //
  ////////////////////
  @override
  Widget build(BuildContext context) {
    final InfraredState infraredState = Provider.of<InfraredState>(context);
    infraredAppState = infraredState;

    String infraredText = infraredState.getReceivedText;
    if (infraredText != "") {
      var nmessage = jsonDecode(infraredText);
      String ndata = nmessage['data'].toString();
      if (ndata == "0") {
        _showPresenceNotification();
      }
    }

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
            PresenceSwitch(
                onchangePresence,
                presenceSwitchControl,
                infraredAppState.getAppConnectionState,
                _configureAndConnect3,
                _disconnect3),
            BreakSwitch(onchangeBreak, breakSwitchControl),
            SoundSwitch(onchangeSound, soundSwitchControl),
            SnackBarPage(updateSchedule, clearSchedule),
            _buildScrollableTextWith(infraredAppState.getHistoryText),
            SizedBox(
              height: 10.0,
            ),
            // _connectionStateDisplay(_prepareStateMessageFrom(
            //     infraredAppState.getAppConnectionState)),
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

  void _configureAndConnect3() {
    infraredManager = MQTTManager(
        host: 'io.adafruit.com',
        // topic: 'khanhdk0000/feeds/infrared-sensor-1',
        topic: 'CSE_BBC1/feeds/bk-iot-infrared',
        adaAPIKey: adaPassword1,
        adaUserName: adaUserName1,
        identifier: _random.nextInt(10).toString(),
        state: infraredAppState);

    infraredManager.initializeMQTTClient();
    infraredManager.connect();
  }

  _getLatestData3() async {
    var req = await http.get(Uri.https(
        'io.adafruit.com', 'api/v2/khanhdk0000/feeds/infrared-sensor-1/data'));
    var infos = json.decode(req.body);
    var temp = infos[0]['value'];
    var temp2 = json.decode(temp);
    return temp2;
  }

  void _disconnect3() {
    infraredManager.disconnect();
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
