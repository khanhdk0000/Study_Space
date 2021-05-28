import 'package:flutter/material.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Schedule/schedule_controller.dart';

const divider = SizedBox(height: 32.0);

class ScheduleScreen extends StatefulWidget {

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override

  var schedule = Schedule();


  Widget build(BuildContext context) {
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
    padding: EdgeInsets.all(32),
    color: Color.fromRGBO(0, 0, 0, 0.06),
    width: double.infinity,
          child: Text(
              "Your schedule is empty at the moment. Try adding some study sessions.",
              textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 50,
                color: Colors.black)
            ),
    );

    var YesSchedule = Container(
        padding: EdgeInsets.all(22),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "You have a schedule!.",
              textAlign: TextAlign.left,
            ),

          ],
        )
    );

    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
          child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [Navigation, divider, schedule.sessions.length == 0 ? NoSchedule:Schedule])),
    );
  }
}
