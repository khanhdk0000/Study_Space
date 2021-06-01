import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/session.dart';
import 'package:study_space/Schedule/view/add_session_screen.dart';


///User arguments
String _username = "Gwen";
int _userid = 2;
final User user = auth.currentUser;


const divider = SizedBox(height: 32.0);

class ScheduleScreen extends StatefulWidget {

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override

  int _sortedBy = 0;
  int timeFrame = 0;
  List<String> _sortSelection = ['Score (H)', 'Score (L)', 'Name (A-Z)', 'Name (Z-A)', 'Time (H)', 'Time (L)'];
  Future<List<Session>> sessions;


  Widget build(BuildContext context) {
    sessions = SessionController().getUnfinishedSessions(_userid, SessionController().setFilter(_sortSelection[_sortedBy]), 30);

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
      children: [
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: timeFrame == 0 ? Colors.black: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // <-- Radius
              ),
            ),
          onPressed: (){setState((){timeFrame = 0;});},
          child: Text(
            "Today"
          )
        ),
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: timeFrame == 1 ? Colors.black: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // <-- Radius
              ),
            ),
            onPressed: (){setState((){timeFrame = 1;});},
            child: Text(
                "All"
            )
        )
      ],
    ));

    var NoSchedule = Container(
    padding: EdgeInsets.all(36),
    color: Color.fromRGBO(0, 0, 0, 0.06),
    width: double.infinity,
          child: Text(
              "Your schedule is empty at the moment. Try adding some study sessions.",
              textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 48,
                color: Colors.black)
            ),
    );

    var Body = FutureBuilder(future: sessions, builder: (context, snapshot){
              if (snapshot.hasData){
                if (snapshot.data.length > 0) {
                return ListBody(
                children: [
                  Filterer,
                for (final session in snapshot.data)
                Container(
                    padding: EdgeInsets.only(bottom: 14),
                  child: SessionButton(session)
                )
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

    final AddButton =  TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        onPressed: ()  => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddSessionScreen()),
        ),
        child:   Container(
          padding: EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Add session  ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 22.0,
              ),
            ],
          ),
        ));

    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
          child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [Navigation, divider, Body, AddButton])),
    );
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