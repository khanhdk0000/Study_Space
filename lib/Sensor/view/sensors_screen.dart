import 'package:flutter/material.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/Sensor/view/body.dart';
import 'package:study_space/constants.dart';


class SensorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kContentColorLightTheme),
        title: Text(
          'Sensor',
          style: TextStyle(
            color: kContentColorLightTheme,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Body(),
    );
  }
}
