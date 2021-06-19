import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/session.dart';
import 'package:study_space/Schedule/view/session_screen.dart';
import 'package:study_space/Schedule/view/add_session_screen.dart';
import 'package:study_space/global.dart';

///User arguments
final User user = auth.currentUser;

const spacer = SizedBox(height: 10.0);

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  final filters = ["Today", "This Week", "This Month", "This Year"];
  String filterMode = "Today";
  Future<List<Session>> loadedSessions;
  List<Session> upcomingSessions;
  List<Session> missedSessions;

  void loadSessions() {
    setState(() {
      int dateRange;
      switch (filterMode) {
        case "Today":
          {
            dateRange = 0;
          }
          break;

        case "This Week":
          {
            dateRange = 7;
          }
          break;

        case "This Month":
          {
            dateRange = 30;
          }
          break;

        case "This Year":
          {
            dateRange = 365;
          }
          break;
      }

      loadedSessions = SessionController().getUnfinishedSessions(
          user_id,
          SessionController().setFilter("Time (L)"),
          dateRange,
          30,
          user.displayName);
      upcomingSessions = [];
      missedSessions = [];
    });
  }

  void filterSessions(List<Session> sessions) {
    for (final session in sessions) {
      final date = session.getDate();
      final startTime = session.getStartTime();

      final now = new DateTime.now();
      final dateDate =
      DateFormat('MM/dd/yyyy hh:mm:ss').parse(date + " " + startTime);
      if (dateDate.isBefore(now)) {
        missedSessions.add(session);
      } else {
        upcomingSessions.add(session);
      }
    }
  }

  Widget build(BuildContext context) {
    loadSessions();

    var Navigation = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MenuButton(),
          Expanded(
            child: Text(
              "Schedule",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black),
            ),
          ),
          SizedBox(width: 50.0),
        ],
      );

    var Filterer = Container(
        color: Color.fromRGBO(0, 0, 0, 0.06),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final filter in filters)
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: filterMode == filter
                        ? Colors.black
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      filterMode = filter;
                    });
                  },
                  child: Text(filter,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: filterMode == filter
                              ? Colors.white
                              : Colors.black))),
          ],
        ));

    final AddButton = TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddSessionScreen(loadSessions)),
            ),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Add event  ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20.0,
              ),
            ],
          ),
        ));

    var NoSchedule = Column(children: [
      Container(
        padding: EdgeInsets.all(36),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        width: double.infinity,
        child: Text(
            "You have nothing scheduled for ${filterMode.toLowerCase()}. Try adding some study sessions.",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 48,
                color: Colors.black)),
      ),
      AddButton
    ]);

    var Body = FutureBuilder(
        future: loadedSessions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              filterSessions(snapshot.data);
              return ListBody(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SessionsCalendar(snapshot.data, filterMode),
                  ),
                  AddButton,
                  Container(
                  color: Colors.black,
                  padding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                  child: Text(upcomingSessions.length > 0 ? "Upcoming sessions":"No upcoming session",
                  style: TextStyle(color: Colors.white)))
                  ,
                  for (final session in upcomingSessions)
                    ListBody(children: [
                      SessionButton(session, loadSessions),
                      divider
                    ]),
                  Container(
                      color: Colors.black,
                      padding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      child: Text(missedSessions.length > 0 ? "Missed sessions":"No missed session",
                          style: TextStyle(color: Colors.white))),
                  for (final session in missedSessions)
                    ListBody(children: [
                      SessionButton(session, loadSessions),
                      divider
                    ]),
                ],
              );
            } else {
              return NoSchedule;
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
              children: [Navigation, spacer, Filterer, Body])),
    );
  }
}

class SessionsCalendar extends StatelessWidget {
  List<Appointment> appointments = [];
  List<String> titles = []; // Ordered list of unique titles
  CalendarController _controller = CalendarController();
  SfCalendar calendarView;

  SessionsCalendar(List<Session> sessions, String displayMode) {
    final timeFormat = DateFormat('MM/dd/yyyy hh:mm:ss');

    for (final session in sessions) {
      final title = session.getTitle();
      if (!titles.contains(title)) {
        titles.add(title);
      }
    }

    for (final session in sessions) {
      final title = session.getTitle();
      appointments.add(Appointment(
          startTime: timeFormat
              .parse(session.getDate() + " " + session.getStartTime()),
          endTime:
              timeFormat.parse(session.getDate() + " " + session.getEndTime()),
          subject: title,
          color: colors[titles.indexOf(title)]));
    }

    switch (displayMode) {
      case "Today":
        {
          _controller.view = CalendarView.day;
        }
        break;

      case "This Week":
        {
          _controller.view = CalendarView.week;
        }
        break;

      default:
        {
          _controller.view = CalendarView.month;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var legend = Container(
      height: 45,
        padding: EdgeInsets.only(left: 18),
        child: ListView(
        scrollDirection: Axis.horizontal,
      children: [
        for (final title in titles)
          Row(
                children: [
                  Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                          color: colors[titles.indexOf(title)],
                          shape: BoxShape.circle
                      )),
                  Text("  "+title+"   ", style: TextStyle(
                      fontWeight: FontWeight.bold
                  ))
                ]
            )
      ]));

    return Column(
      children: [
        Container(
            height: 470,
            padding: EdgeInsets.only(top: 4),
            child: SfCalendar(
              view: _controller.view,
              controller: _controller,
              dataSource: SessionDataSource(appointments),
            )),
        legend
      ],
    );
  }
}

class SessionDataSource extends CalendarDataSource {
  SessionDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class SessionButton extends StatelessWidget {
  void Function() reloadParent;
  Session session;
  String title;
  String date;
  String startTime;
  String endTime;

  SessionButton(Session session, void Function() reloadParent) {
    this.reloadParent = reloadParent;
    this.session = session;
    title = session.getTitle();
    date = session.getDate();
    startTime = session.getStartTime().substring(0, 5);
    endTime = session.getEndTime().substring(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SessionScreen(session, reloadParent)),
            ),
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$title",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black)),
                Text("$date",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.grey)),
                Text("From $startTime to $endTime",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.grey)),
              ],
            )));
  }
}
