import 'package:flutter/material.dart';
import 'package:study_space/constants.dart';

class StudySwitch extends StatelessWidget {
  final Function onchange;
  final bool switchControl;
  StudySwitch(this.onchange, this.switchControl);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Allow Study Notification"),
        Switch(
          value: switchControl,
          onChanged: (bool value) => onchange(value),
          activeColor: kPrimaryColor,
        ),
      ],
    );
  }
}

class PresenceSwitch extends StatelessWidget {
  final Function onchangePresence;
  final bool presenceSwitchControl;
  final MQTTAppConnectionState state;
  final String receivedText;
  // final Function connect;
  // final Function disconnect;
  PresenceSwitch(this.onchangePresence, this.presenceSwitchControl, this.state,
      this.receivedText);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Allow Presence Notification"),
        Switch(
          value: presenceSwitchControl,
          onChanged: (bool value) =>
              // onchangePresence(value, state, connect, disconnect),
              onchangePresence(value, state, receivedText.substring(37, 38)),
          activeColor: kPrimaryColor,
        ),
      ],
    );
  }
}

class BreakSwitch extends StatelessWidget {
  final Function onchangeBreak;
  final bool breakSwitchControl;
  BreakSwitch(this.onchangeBreak, this.breakSwitchControl);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Allow Break Notification"),
        Switch(
          value: breakSwitchControl,
          onChanged: (bool value) => onchangeBreak(value),
          activeColor: kPrimaryColor,
        ),
      ],
    );
  }
}

class SoundSwitch extends StatelessWidget {
  final Function onchangeSound;
  final bool soundSwitchControl;
  SoundSwitch(this.onchangeSound, this.soundSwitchControl);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Allow Sound"),
        Switch(
          value: soundSwitchControl,
          onChanged: (bool value) => onchangeSound(value),
          activeColor: kPrimaryColor,
        ),
      ],
    );
  }
}

class SnackBarPage extends StatelessWidget {
  final Function updateSchedule;
  final Function clearSchedule;
  SnackBarPage(this.updateSchedule, this.clearSchedule);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () async {
              await updateSchedule();
              final snackBar = SnackBar(
                content: Text('Updated Successfully!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    clearSchedule();
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text('Update schedule',
                style: TextStyle(color: kContentColorLightTheme)),
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
            ),
          ),
          // ElevatedButton(
          //   onPressed: connect(),
          //   child: Text('Current presence',
          //       style: TextStyle(color: kContentColorLightTheme)),
          //   style: ElevatedButton.styleFrom(
          //     primary: kPrimaryColor,
          //   ),
          // ),
        ],
      ),
    );
  }
}
