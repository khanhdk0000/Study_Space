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
        color: Color.fromRGBO(0, 0, 0, 0.06),
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
            "     Allow Study Notification",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Switch(
            value: switchControl,
            onChanged: (bool value) => onchange(value),
            activeColor: kPrimaryColor,
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
        color: Color.fromRGBO(0, 0, 0, 0.06),
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
            "     Allow Presence Notification",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Switch(
            value: presenceSwitchControl,
            onChanged: (bool value) async => onchangePresence(value),
            activeColor: kPrimaryColor,
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
        color: Color.fromRGBO(0, 0, 0, 0.06),
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
            "     Allow Break Notification",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Switch(
            value: breakSwitchControl,
            onChanged: (bool value) => onchangeBreak(value),
            activeColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}

class SoundSwitch extends StatelessWidget {
  final Function onchangeSound;
  final bool soundSwitchControl;
  SoundSwitch(this.onchangeSound, this.soundSwitchControl);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.06),
        border: Border(
          top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
          bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.volume_off_rounded,
            color: Colors.black,
            size: 25.0,
          ),
          Text(
            "     Allow Sound",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Spacer(),
          Switch(
            value: soundSwitchControl,
            onChanged: (bool value) => onchangeSound(value),
            activeColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
