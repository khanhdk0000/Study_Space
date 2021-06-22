import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/Schedule/view/schedule_screen.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/session.dart';
import 'package:study_space/global.dart';
import 'dart:io';
import 'package:syncfusion_flutter_calendar/calendar.dart';

///User arguments
final User user = auth.currentUser;

const spacer = SizedBox(height: 20.0);

class SessionScreen extends StatefulWidget {
  Session session;
  final void Function() reloadParent;

  SessionScreen(this.session, this.reloadParent);

  @override
  _SessionScreenState createState() =>
      _SessionScreenState(session, reloadParent);
}

class _SessionScreenState extends State<SessionScreen> {
  void Function() reloadParent;
  Session session;
  Future<List<Session>> todaySessions;
  String title;
  String date;
  String upcoming;
  int duration;
  String startTime;
  String endTime;

  _SessionScreenState(Session session, void Function() reloadParent) {
    this.reloadParent = reloadParent;
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
    if (difference == 0) {
      upcoming = "Scheduled for today";
    } else if (difference < 0) {
      upcoming = "You missed this event";
    } else {
      upcoming = "Scheduled for ${difference} days from now";
    }
  }

  final bodyText = TextStyle(fontWeight: FontWeight.normal, fontSize: 17);

  @override
  Widget build(BuildContext context) {
    todaySessions = SessionController().getUnfinishedSessions(user_id,
        SessionController().setFilter("Time (L)"), 365, 30, user.displayName,context);

    var Navigation = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ReturnButton(),
            Text(
              "Session",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
          ],
        ),
      ],
    );

    final DeleteButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // <-- Radius
        ),
      ),
      onPressed: () {
        SessionController().removeSession(
            date, startTime, endTime, title, user_id, user.displayName,context);
        sleep(Duration(milliseconds: 600));
        reloadParent();
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.close,
              color: Colors.white,
              size: 20.0,
            ),
            Text(
              "  Remove this event  ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

    var Summary = Container(
      color: Color.fromRGBO(0, 0, 0, 0.06),
        padding: EdgeInsets.all(22),
        child: ListBody(
          children: [
            Text(title,
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            spacer,
            Text("$upcoming - $date", style: bodyText),
            Text("About $duration minutes - From $startTime to $endTime",
                style: bodyText),
          ],
        ));

    var Timeline = FutureBuilder(
        future: todaySessions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return SessionsTimeline(snapshot.data, session);
            } else {
              return Text("There is no event for today");
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return LoadingIndicator;
        });

    return Scaffold(
        drawer: SideMenu(),
        body: SafeArea(
          child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                Navigation,
                Summary,
                Timeline,
                DeleteButton
              ]),
        ));
  }
}

class SessionsTimeline extends StatelessWidget {
  List<Appointment> appointments = [];
  List<String> titles = []; // Ordered list of unique titles
  Session pivot;
  SfCalendar calendarView;

  SessionsTimeline(List<Session> sessions, Session pivot) {
    final timeFormat = DateFormat('MM/dd/yyyy hh:mm:ss');

    this.pivot = pivot;
    final pivotTitle = pivot.getTitle();
    for (final session in sessions) {
      final title = session.getTitle();
      appointments.add(Appointment(
          startTime: timeFormat
              .parse(session.getDate() + " " + session.getStartTime()),
          endTime:
              timeFormat.parse(session.getDate() + " " + session.getEndTime()),
          subject: title,
          color: title == pivotTitle ? Colors.blue:Colors.grey));
    }
  }

  @override
  Widget build(BuildContext context) {
    var legend = Container(
        height: 32,
        padding: EdgeInsets.only(left: 18),
        child: Row(children: [
            Row(children: [
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle)),
              Text("  " + pivot.getTitle() + "   ",
                  style: TextStyle(fontWeight: FontWeight.bold))
            ]),
          Row(children: [
            Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle)),
            Text("  " + "Other events" + "   ",
                style: TextStyle(fontWeight: FontWeight.bold))
          ])
        ]));

    return Column(
      children: [
        Container(
            height: 180,
            padding: EdgeInsets.only(top: 4, left: 18),
            child: SfCalendar(
              view: CalendarView.timelineDay,
              initialDisplayDate:  DateFormat('MM/dd/yyyy').parse(pivot.getDate()),
              dataSource: SessionDataSource(appointments),
            )),
        divider,
        legend
      ],
    );
  }
}
