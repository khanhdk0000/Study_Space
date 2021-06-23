import 'package:flutter/material.dart';
import 'package:study_space/constants.dart';

class StudySwitch extends StatelessWidget {
  final Function onchange;
  final bool switchControl;
  StudySwitch(this.onchange, this.switchControl);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: switchControl == false
            ? Color.fromRGBO(0, 0, 0, 0.3)
            : Color.fromRGBO(0, 0, 0, 0.06),
        border: Border(top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06))),
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle_notifications_sharp,
            color: Colors.black,
            size: 25.0,
          ),
          Text(
            "     Study Notification",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Switch(
            value: switchControl,
            onChanged: (bool value) => onchange(value),
            activeColor: kPrimaryColor,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class PresenceSwitch extends StatelessWidget {
  final Function onchangePresence;
  final bool presenceSwitchControl;
  PresenceSwitch(this.onchangePresence, this.presenceSwitchControl);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: presenceSwitchControl == false
            ? Color.fromRGBO(0, 0, 0, 0.3)
            : Color.fromRGBO(0, 0, 0, 0.06),
        border: Border(top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06))),
      ),
      child: Row(
        children: [
          Icon(
            Icons.airline_seat_recline_normal_sharp,
            color: Colors.black,
            size: 25.0,
          ),
          Text(
            "     Presence Notification",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Switch(
            value: presenceSwitchControl,
            onChanged: (bool value) async => onchangePresence(value),
            activeColor: kPrimaryColor,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class BreakSwitch extends StatelessWidget {
  final Function onchangeBreak;
  final bool breakSwitchControl;
  BreakSwitch(this.onchangeBreak, this.breakSwitchControl);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: breakSwitchControl == false
            ? Color.fromRGBO(0, 0, 0, 0.3)
            : Color.fromRGBO(0, 0, 0, 0.06),
        border: Border(top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06))),
      ),
      child: Row(
        children: [
          Icon(
            Icons.videogame_asset_rounded,
            color: Colors.black,
            size: 25.0,
          ),
          Text(
            "     Break Notification",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Switch(
            value: breakSwitchControl,
            onChanged: (bool value) => onchangeBreak(value),
            activeColor: kPrimaryColor,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class SoundSensorSwitch extends StatelessWidget {
  final Function sensorSound;
  final bool sound;
  SoundSensorSwitch(this.sensorSound, this.sound);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: sound == false
            ? Color.fromRGBO(0, 0, 0, 0.3)
            : Color.fromRGBO(0, 0, 0, 0.06),
        border: Border(
          top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
          bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.surround_sound_rounded,
            color: Colors.black,
            size: 25.0,
          ),
          Text(
            "     Sound Sensor Notification",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Spacer(),
          Switch(
            value: sound,
            onChanged: (bool value) => sensorSound(value),
            activeColor: kPrimaryColor,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class LightSensorSwitch extends StatelessWidget {
  final Function sensorLight;
  final bool light;
  LightSensorSwitch(this.sensorLight, this.light);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: light == false
            ? Color.fromRGBO(0, 0, 0, 0.3)
            : Color.fromRGBO(0, 0, 0, 0.06),
        border: Border(
          top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
          bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wb_incandescent_rounded,
            color: Colors.black,
            size: 25.0,
          ),
          Text(
            "     Light Sensor Notification",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Spacer(),
          Switch(
            value: light,
            onChanged: (bool value) => sensorLight(value),
            activeColor: kPrimaryColor,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class TempSensorSwitch extends StatelessWidget {
  final Function sensorTemp;
  final bool temp;
  TempSensorSwitch(this.sensorTemp, this.temp);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: temp == false
            ? Color.fromRGBO(0, 0, 0, 0.3)
            : Color.fromRGBO(0, 0, 0, 0.06),
        border: Border(
          top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
          bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.whatshot_rounded,
            color: Colors.black,
            size: 25.0,
          ),
          Text(
            "     Temperature Sensor Notification",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Spacer(),
          Switch(
            value: temp,
            onChanged: (bool value) => sensorTemp(value),
            activeColor: kPrimaryColor,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
