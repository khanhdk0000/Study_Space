import 'package:flutter/material.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Schedule/schedule_controller.dart';
import 'package:study_space/Schedule/view/edit_schedule_screen.dart';

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

    final EditButton =  TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        onPressed: ()  => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditScheduleScreen()),
        ),
        child:   Container(
          padding: EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Edit Schedule  ",
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
              children: [Navigation, divider, schedule.sessions.length == 0 ? NoSchedule:YesSchedule, EditButton])),
    );
  }
}
