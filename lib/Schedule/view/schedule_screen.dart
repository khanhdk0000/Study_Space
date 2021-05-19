import 'package:flutter/material.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';

const divider = SizedBox(height: 32.0);

class ScheduleScreen extends StatefulWidget {

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override


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

    var Body = Container(
    padding: EdgeInsets.all(22),
    color: Color.fromRGBO(0, 0, 0, 0.06),
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
            "",
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
              children: [Navigation, divider, Body])),
    );
  }
}
