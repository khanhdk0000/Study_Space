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


const spacer = SizedBox(height: 16.0);

class ScheduleScreen extends StatefulWidget {

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override

  final filters = ["Today", "Next Week", "Next Month", "Next Year"];
  String filterMode = "Next Month";
  Future<List<Session>> sessions;

  void loadSessions(){
    setState(() {
    int dateRange;
    switch(filterMode) {
      case "Today": {
        dateRange = 0;
      }
      break;

      case "Next Week": {
        dateRange = 7;
      }
      break;

      case "Next Month": {
        dateRange = 30;
      }
      break;

      case "Next Year": {
        dateRange = 365;
      }
      break;
    }

    sessions = SessionController().getUnfinishedSessions(user_id, SessionController().setFilter("Time (L)"),
        dateRange, 30, user.displayName);
    });
  }

  Widget build(BuildContext context) {
    loadSessions();

    var Navigation = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MenuButton(),
          Text("Schedule", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black),
          )
        ],
      ),
    ]);

    var Filterer = Container (
        color: Color.fromRGBO(0, 0, 0, 0.06),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final filter in filters)
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: filterMode == filter ? Colors.black: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // <-- Radius
                    ),
                  ),
                  onPressed: (){setState((){
                    filterMode = filter;
                  });},
                  child: Text(
                      filter, style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: filterMode == filter ? Colors.white: Colors.black)
                  )
              ),
          ],
        ));

    final AddButton =  TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        onPressed: ()  => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddSessionScreen(loadSessions)),
        ),
        child:   Container(
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

    var NoSchedule = Column(
        children: [Container(
      padding: EdgeInsets.all(36),
      color: Color.fromRGBO(0, 0, 0, 0.06),
      width: double.infinity,
      child: Text(
          "You have nothing scheduled for ${filterMode.toLowerCase()}. Try adding some study sessions.",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 48,
              color: Colors.black)
      ),
    ),
          AddButton
        ]
    );

    var Body = FutureBuilder(future: sessions, builder: (context, snapshot){
      if (snapshot.hasData){

        if (snapshot.data.length > 0) {
          return ListBody(
            children: [
              SessionsScatter(snapshot.data),
              AddButton,
              for (final session in snapshot.data)
                ListBody(
                    children: [
                      SessionButton(session, loadSessions),
                      divider
                    ]
                ),
            ],
          );
        }
        else {
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


class SessionsScatter extends StatelessWidget{
  List<Appointment> appointments = [];
  List<String> titles = [];  // Ordered list of unique titles

  SessionsScatter(List<Session> sessions){
    final timeFormat = DateFormat('MM/dd/yyyy hh:mm:ss');
    final timeFormat2 = DateFormat('hh:mm:ss');
    print(timeFormat.parse(sessions[0].getDate() + " " + sessions[0].getStartTime()));
    print(timeFormat.parse(sessions[0].getDate() + " " + sessions[0].getEndTime()));
    print(timeFormat2.parse(sessions[0].getStartTime()));

    for (final session in sessions){
      final title = session.getTitle();
      if (!titles.contains(title)){
        appointments.add(Appointment(
          startTime: timeFormat.parse(session.getDate() + " " + session.getStartTime()),
            endTime: timeFormat.parse(session.getDate() + " " + session.getEndTime()),
          subject: session.getTitle(),
          color: Colors.blue
        ));
      }
    }

    for (final session in sessions){
        appointments.add(Appointment(
            startTime: timeFormat.parse(session.getDate() + " " + session.getStartTime()),
            endTime: timeFormat.parse(session.getDate() + " " + session.getEndTime()),
            subject: session.getTitle()
        ));
    }

  }

  @override
  Widget build(BuildContext context) {
    var legend = Row(
      children: [
        for (final title in titles)
          Container(
            padding: EdgeInsets.only(left: 24),
            child: Row(
                children: [
                  Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                          color: colors[titles.indexOf(title)],
                          shape: BoxShape.circle
                      )),
                  Text("  "+title, style: TextStyle(
                      fontWeight: FontWeight.bold
                  ))
                ]
            ),
          )
      ],
    );

    return Container(
      height: 480,
      color: Color.fromRGBO(0, 0, 0, 0.06),
      child: ListView(
        // This next line does the trick.
          scrollDirection: Axis.horizontal,
          children: [Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 440,
                  width: 500,
                  padding: EdgeInsets.only(top: 20, right: 24, bottom: 10),
                  child: SfCalendar(
                    view: CalendarView.week,
                    timeSlotViewSettings: TimeSlotViewSettings(
                        startHour: 9,
                        endHour: 16,
                        nonWorkingDays: <int>[DateTime.friday, DateTime.saturday]),
                    dataSource: SessionDataSource(appointments),
                  )),
              legend
            ],
          )]),
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
  SessionButton(Session session, void Function() reloadParent){
    this.reloadParent = reloadParent;
    this.session = session;
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
          MaterialPageRoute(builder: (context) => SessionScreen(session, reloadParent)),
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
                Text("$title", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)),
                Text("$date", style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.black)),
                Text("From $startTime to $endTime", style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.black)),
              ],
            )
        ));
  }
}