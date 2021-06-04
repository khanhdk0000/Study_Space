import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/session.dart';


///User arguments
String _username = "Gwen";
int _userid = 2;
final User user = auth.currentUser;


const spacer = SizedBox(height: 20.0);
final divider = Container(height: 1.0, color: Colors.black26);

class SessionScreen extends StatefulWidget {
  Session session;

  SessionScreen(Session session){
    this.session = session;
  }

  @override
  _SessionScreenState createState() => _SessionScreenState(session);
}

class _SessionScreenState extends State<SessionScreen> {
  Session session;
  String title;
  String date;
  String upcoming;
  int duration;
  String startTime;
  String endTime;

  _SessionScreenState(Session session){
    this.session = session;
    this.title = session.getTitle();
    this.date = session.getDate();
    this.duration = session.getDuration();
    this.startTime = session.getStartTime();
    this.endTime = session.getEndTime();

    final now = new DateTime.now();
    final today = new DateTime(now.year, now.month, now.day);
    final dateDate = DateFormat('MM/dd/yyyy').parse(date);
    final difference = dateDate.difference(today).inDays;
    if (difference == 0){
      upcoming = "Scheduled for today";
    }
    else if (difference < 0) {
      upcoming = "You missed this event";
    }
    else {
      upcoming = "Scheduled for ${difference} days from now";
    }
  }

  final bodyText = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17
  );

  @override

  Widget build(BuildContext context) {

    var Navigation = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ReturnButton(),
          Text("Session", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black),
          )
        ],
      ),
    ]);

    final DeleteButton =  TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        onPressed: () {
          SessionController().removeSession(date, startTime, endTime, title, _userid);
          Navigator.pop(context);
        },
        child:   Container(
          padding: EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Remove event  ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));

    var Body = Container(
      padding: EdgeInsets.all(22),
        child: ListBody(
            children: [
              Text(title, style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              )),
              spacer,
              Text("$upcoming - $date", style: bodyText),
              Text("About $duration minutes - From $startTime to $endTime", style: bodyText),

            ],
          ));


    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
      child:ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [Navigation, Body, DeleteButton]),
    ));
  }
}