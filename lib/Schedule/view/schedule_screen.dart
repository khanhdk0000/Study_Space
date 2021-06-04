import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/session.dart';
import 'package:study_space/Schedule/view/session_screen.dart';
import 'package:study_space/Schedule/view/add_session_screen.dart';


///User arguments
String _username = "Gwen";
int _userid = 2;
final User user = auth.currentUser;


const spacer = SizedBox(height: 20.0);
final divider = Container(height: 1.0, color: Colors.black26);
const colors = [Colors.blue, Colors.amber, Colors.green, Colors.lime, Colors.orange, Colors.purple, Colors.red];

class ScheduleScreen extends StatefulWidget {

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override

  int _sortedBy = 5;
  final filters = ["Today", "Next Week", "Next Month", "Next Year"];
  String filterMode = "Next Month";
  List<String> _sortSelection = ['Score (H)', 'Score (L)', 'Name (A-Z)', 'Name (Z-A)', 'Time (H)', 'Time (L)'];
  Future<List<Session>> sessions;


  Widget build(BuildContext context) {
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
    final maxDate = DateTime.now().add(Duration(days: dateRange));
    String formattedDate = DateFormat('MM/dd/yyyy').format(maxDate);

    sessions = SessionController().getUnfinishedSessions(_userid, SessionController().setFilter(_sortSelection[_sortedBy]),formattedDate , 30);

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
          onPressed: (){setState((){filterMode = filter;});},
          child: Text(
            filter, style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: filterMode == filter ? Colors.white: Colors.black)
          )
        ),
      ],
    ));

    var NoSchedule = Container(
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
    );

    final AddButton =  TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        onPressed: ()  => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddSessionScreen()),
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
                      SessionButton(session),
                      divider
                    ]
                ),
              SessionsPie(snapshot.data),
            ],
          );
        }
        else {
          return NoSchedule;
        }
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return Text('Loading...');
    });

    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
          child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [Navigation, spacer, Filterer, Body, AddButton])),
    );
  }
}

class SessionsPie extends StatelessWidget{
  List<PieChartSectionData> pieData = [];
  final colors = [Colors.blue, Colors.amber, Colors.green, Colors.lime, Colors.orange, Colors.purple, Colors.red];

  SessionsPie(List<Session> sessions){
    Set<String> titles = {};
    for (final session in sessions) {
      titles.add(session.getTitle());
    }

    for (var i = 0 ; i < titles.length; i++) {
      var totalMinutes = 0.0;
      for (final session in sessions) {
        if (session.getTitle() == titles.elementAt(i)) {
            totalMinutes += session.getDuration();
        }
      }
      pieData.add(PieChartSectionData(
        title: titles.elementAt(i),
        value: totalMinutes,
        color:colors[i],
        radius: 140,
      ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        height: 320,
        color: Color.fromRGBO(0, 0, 0, 0.06),
        child: PieChart(
          PieChartData(
            sections: pieData,
            sectionsSpace: 0,
            centerSpaceRadius: 0,
          ),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        ));
  }
}

class SessionsScatter extends StatelessWidget{
  List<ScatterSpot> sessionSpots = [];
  List<String> titles = [];  // Ordered list of unique titles

  SessionsScatter(List<Session> sessions){
    for (final session in sessions){
      final title = session.getTitle();
      if (!titles.contains(title)){
        titles.add(title);
      }
    }

    final now = new DateTime.now();
    var today = new DateTime(now.year, now.month, now.day);
    for (var i = 1; i <= 7; i++) {
      for (final session in sessions) {
        if (DateFormat('MM/dd/yyyy').parse(session.getDate()).isAtSameMomentAs(today)){
          final startTime = DateFormat('hh:mm:ss').parse(session.getStartTime());
          final startMinute = startTime.hour + startTime.minute.toDouble()/100;
          sessionSpots.add(ScatterSpot(i.toDouble(), startMinute,
            color: colors[titles.indexOf(session.getTitle())]
          ));
        }
      }
      today = today.add(Duration(days: 1));
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
              child: ScatterChart(
                ScatterChartData(
                  scatterSpots: sessionSpots,
                  minX: 1,
                  maxX: 7,
                  minY: 0,
                  maxY: 24.toDouble(),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    checkToShowHorizontalLine: (value) => true,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.black12),
                    drawVerticalLine: true,
                    checkToShowVerticalLine: (value) => true,
                    getDrawingVerticalLine: (value) => FlLine(color: Colors.black12),
                  ),
                ),
                swapAnimationDuration: Duration(milliseconds: 150), // Optional
                swapAnimationCurve: Curves.linear, // Optional
              )),
              legend
            ],
          )]),
    );
  }
}

class SessionButton extends StatelessWidget {
  Session session;
  String title;
  String date;
  String startTime;
  String endTime;
  SessionButton(Session session){
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
          MaterialPageRoute(builder: (context) => SessionScreen(session)),
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