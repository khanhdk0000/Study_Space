import 'package:flutter/material.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';

const divider = SizedBox(height: 32.0);

class CountdownScreen extends StatefulWidget {
  var hours;
  var minutes;
  var seconds;

  CountdownScreen(int hours, int minutes, int seconds) {
    this.hours = hours;
    this.minutes  = minutes;
    this.seconds = seconds;
  }

  @override
  _CountdownScreenState createState() => _CountdownScreenState(hours, minutes, seconds);
}

class _CountdownScreenState extends State<CountdownScreen> {
  _CountdownScreenState(int hours, int minutes, int seconds) {
    this.hours = hours;
    this.minutes  = minutes;
    this.seconds = seconds;
  }

  @override
  var hours;
  var minutes;
  var seconds;
  final descriptions = [
    "There's still time. Focus on your work."
  ];

  final counterTextStyle = TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 60,
      color: Colors.black);



  Widget build(BuildContext context) {
    var Description = Container(
        padding: EdgeInsets.all(36),
      color: Colors.black,
        child: Text(
          descriptions[0],
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: 60,
        color: Colors.white,
      ),
    )
    );

    var Counter = Container(
        padding: EdgeInsets.all(22),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${hours.toString().padLeft(2, '0')}",
                  textAlign: TextAlign.left,
                  style: counterTextStyle,
                ),
                Text(
                  ":",
                  textAlign: TextAlign.left,
                  style: counterTextStyle,
                ),
                Text(
                  "${minutes.toString().padLeft(2, '0')}",
                  textAlign: TextAlign.left,
                  style: counterTextStyle,
                ),
                Text(
                  ":",
                  textAlign: TextAlign.left,
                  style: counterTextStyle,
                ),
                Text(
                  "${seconds.toString().padLeft(2, '0')}",
                  textAlign: TextAlign.left,
                  style: counterTextStyle,
                ),
              ],
            ),
          ],
        )
    );

    var Navigation = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ReturnButton(),
          Text("Timer", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black),
          )
        ],
      ),
    ]);


    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
          child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [Navigation, divider, Description, Counter])),
    );
  }
}
