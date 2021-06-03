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


const divider = SizedBox(height: 20.0);

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
  String startTime;
  String endTime;

  _SessionScreenState(Session session){
    this.session = session;
    this.title = session.getTitle();
    this.date = session.getDate();
    this.startTime = session.getStartTime();
    this.endTime = session.getEndTime();

    final today = DateTime.now();
    final dateDate = DateFormat('MM/dd/yyyy').parse(date);
    final difference = today.difference(dateDate);
    if (difference.inDays == 0){
      upcoming = "Coming later today";
    }
    else if (dateDate.isBefore(today)) {
      upcoming = "You missed this session";
    }
    else {
      upcoming = "Coming in ${difference.inDays} days";
    }
  }

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

    var Body = ListBody(
            children: [
              Text(title, style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              )),
              Text("$upcoming - $date"),
              Text("From $startTime to $endTime"),

            ],
          );


    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
      child:ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [Navigation, divider, Body]),
    ));
  }
}


class SessionButton extends StatelessWidget {
  // HomeScreen({this.user});
  String title;
  String date;
  String startTime;
  String endTime;
  SessionButton(Session session){
    title = session.getTitle();
    date = session.getDate();
    startTime = session.getStartTime().substring(0,5);
    endTime = session.getEndTime().substring(0,5);
  }

  @override
  Widget build(BuildContext context) {

    return TextButton(
        onPressed: ()  => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$title", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black)),
                Text("$date", style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.black)),
                Text("From $startTime to $endTime", style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black)),
              ],
            )
        ));
  }
}