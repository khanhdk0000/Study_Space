import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Schedule/view/schedule_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/session.dart';
import 'package:study_space/global.dart';

const divider = SizedBox(height: 32.0);
final FirebaseAuth auth = FirebaseAuth.instance;

///User arguments
final User _user = auth.currentUser;

class HomeScreen extends StatelessWidget {
  // HomeScreen({this.user});
  final progress = 75;

  @override
  Widget build(BuildContext context) {
    var topSummary = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MenuButton(),
          CircleAvatar(
            radius: 90.0,
            backgroundImage: AssetImage('assets/img/portrait.png'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: () {},
            child: Icon(Icons.refresh, color: Colors.black, size: 24.0),
          )
        ],
      ),
      SizedBox(height: 22),
      Text(
        _user == null ? "Anonymous" : _user.displayName,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      Text(
        "$progress% study goal completed",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black38),
      )
    ]);

    return Scaffold(
      drawer: SideMenu(),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [topSummary, divider, HomeSchedule()],
              ),
            ),
    );
  }
}

class HomeSchedule extends StatelessWidget {
  Future<List<Session>> sessions;

  @override
  Widget build(BuildContext context) {
    sessions = SessionController().getUnfinishedSessions(user_id, SessionController().setFilter("Time (L)"),
        0, 30, _user.displayName);

    return FutureBuilder(future: sessions, builder: (context, snapshot){
      if (snapshot.hasData){
        final now = DateTime.now();
        final dateFormat = DateFormat('MM/dd/yyyy hh:mm:ss');
        List<Session> todaySessions = snapshot.data;
        todaySessions = todaySessions.where((a) => dateFormat.parse(a.getDate() + " " + a.getStartTime()).isAfter(now)).toList();

        if (todaySessions.length > 0) {
          todaySessions.sort((a, b) =>
                dateFormat.parse(a.getDate() + " " + a.getStartTime())
                    .compareTo(
                    dateFormat.parse(b.getDate() + " " + b.getStartTime())));

          final nextSession = todaySessions[0];
          final eta = dateFormat.parse(nextSession.getDate() + " " + nextSession.getStartTime()).difference(now).inMinutes;

          return       Column(
            children: [
              Container(
                  padding: EdgeInsets.all(22),
                  color: Colors.black,
                  width: double.infinity,
                  child: Text(
                    "Your next study event is ${nextSession.getTitle()}, starting in ${eta} minutes",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.white),
                  )),
              Container(
                  padding: EdgeInsets.all(26),
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                  width: double.infinity,
                  child: Column(children: [
                    for (var i = 0; i < todaySessions.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Container(
                                  width: 4.0,
                                  height: 4.0,
                                  decoration: BoxDecoration(
                                      color: colors[i], shape: BoxShape.circle),
                                ),
                                Text(
                                  "  ${todaySessions[i].getTitle()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ]),
                              Text(
                                "${todaySessions[i].getStartTime()} : ${todaySessions[i].getEndTime()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.black),
                              )
                            ]),
                      ),
                    SizedBox(height: 26),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScheduleScreen()),
                        );
                      },
                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text(
                          "Show my schedule  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 22.0,
                        ),
                      ]),
                    )
                  ])),
            ],
          );
        }
        else {
          return Container(
              padding: EdgeInsets.all(26),
              color: Color.fromRGBO(0, 0, 0, 0.06),
              child: Text("You don't have any upcoming study event for today", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black))
          );
        }
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return Text('Loading...');
    });
  }
}
