import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/schedController.dart';
import 'package:study_space/Model/schedule.dart';
import 'package:study_space/Schedule/view/edit_schedule_screen.dart';
import 'package:study_space/Schedule/view/add_schedule_screen.dart';


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

  Future<List<Schedule>> schedules;


  Widget build(BuildContext context) {
    schedules = schedController().getSched(_userid);

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

    var Body = FutureBuilder(future: schedules, builder: (context, snapshot){
              if (snapshot.hasData){
                if (snapshot.data.length > 0) {
                return ListBody(
                children: [
                for (final schedule in snapshot.data)
                Container(
                    padding: EdgeInsets.only(bottom: 14),
                  child: ScheduleButton(schedule)
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
          MaterialPageRoute(builder: (context) => AddScheduleScreen()),
        ),
        child:   Container(
          padding: EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Add schedule  ",
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


class ScheduleButton extends StatelessWidget {
  // HomeScreen({this.user});
  String date;
  String startTime;
  String endTime;
  ScheduleButton(Schedule schedule){
    date = schedule.upcomingDate();
   startTime = schedule.start_time;
   endTime = schedule.end_time;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text("$date", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.black)),
          Text("From $startTime to $endTime", style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: Colors.black)),
        ],
      )
    );
  }
}