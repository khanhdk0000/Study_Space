import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/global.dart';
import 'package:study_space/Notification/notification_screen.dart';

///User arguments
final User user = auth.currentUser;

const spacer = SizedBox(height: 20.0);

class AddSessionScreen extends StatefulWidget {
  final void Function() loadSchedule;

  AddSessionScreen(this.loadSchedule);

  @override
  _AddSessionScreenState createState() => _AddSessionScreenState(loadSchedule);
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final void Function() reloadParent;
  var subject = "Untitled";
  var startDate = DateTime.now();
  var startTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 1)));
  var endTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 5)));
  int repeat = 0;
  int period = 1;

  String timeToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    final converted = "$hour:$minute:00";
    return converted;
  }

  String dateToString(DateTime date) {
    final formatter = DateFormat("MM/dd/yyyy");

    final converted = formatter.format(date);
    return converted;
  }

  void setTime(String field) async {
    final newTime = await showTimePicker(
      initialTime: field == "Start Time" ? startTime : endTime,
      context: context,
    );
    if (newTime != null) {
      setState(() {
        if (field == "Start Time") {
          startTime = newTime;
        } else {
          endTime = newTime;
        }
      });
    }
  }

  void setDate() async {
    final newDate = await showDatePicker(
      initialDate: startDate,
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2024),
    );
    if (newDate != null) {
      setState(() {
        startDate = newDate;
      });
    }
  }

  @override
  _AddSessionScreenState(this.reloadParent);

  final divider = Container(height: 1.0, color: Colors.black26);

  final bodyText =
      TextStyle(fontWeight: FontWeight.w100, fontSize: 20, color: Colors.black);

  _displayDialog(BuildContext context, String type, String intialValue) async {
    return showDialog(
        context: context,
        builder: (context) {
          final controller = TextEditingController(text: intialValue);
          return AlertDialog(
            title: Text('$type'),
            content: TextField(
              controller: controller,
              textInputAction: TextInputAction.go,
            ),
            actions: <Widget>[
              TextButton(
                child: new Text('Ok'),
                onPressed: () {
                  setState(() {
                    switch (type) {
                      case "Event Name":
                        {
                          subject = controller.text;
                        }
                        break;

                      case "Period":
                        {
                          period = int.parse(controller.text);
                        }
                        break;

                      case "Repeat":
                        {
                          repeat = int.parse(controller.text);
                        }
                        break;
                    }
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    var navigation = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ReturnButton(),
          Text(
            "New Study Event",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          )
        ],
      ),
    ]);

    final subjectField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: () => _displayDialog(context, "Event Name", subject),
            child: Text(
              "Event name : $subject",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 30,
                  color: Colors.black),
            )));

    final dateField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: () => setDate(),
            child: Text(
              "Begins on: ${dateToString(startDate)}",
              textAlign: TextAlign.left,
              style: bodyText,
            )));

    final startTimeField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: () => setTime("Start Time"),
            child: Text(
              "Start time: ${timeToString(startTime)}",
              textAlign: TextAlign.left,
              style: bodyText,
            )));

    final endTimeField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: () => setTime("End Time"),
            child: Text(
              "End time: ${timeToString(endTime)}",
              textAlign: TextAlign.left,
              style: bodyText,
            )));

    final repeatField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: () =>
                _displayDialog(context, "Repeat", repeat.toString()),
            child: Text(
              "Repeat: $repeat times",
              textAlign: TextAlign.left,
              style: bodyText,
            )));

    final periodField = Container(
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 24, right: 20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: () =>
                _displayDialog(context, "Period", period.toString()),
            child: Text(
              "Duration between each repeat: $period days",
              textAlign: TextAlign.left,
              style: bodyText,
            )));

    final saveButton = TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        onPressed: () async {
          var error = "";
          if (subject.length == 0) {
            error = "You need a name for your event.";
          } else if (startTime.minute > endTime.minute &&
              startTime.hour >= endTime.hour) {
            error = "You can't end an event before it even started.";
          }

          if (error.length > 0) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Oh no'),
                content: Text(error),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            var s = await SessionController().addSessions(
              repeat,
              period,
              dateToString(startDate),
              timeToString(startTime),
              timeToString(endTime),
              subject,
              userId,
              context,
              username: user.displayName,
            );

            if (s == true) {
              reloadParent();
              //schedule.addSession(subject, timeframe);
              Navigator.pop(context);
              NotificationScreen initNoti = new NotificationScreen();
              initNoti.pushNoti();
            }
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 22, top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20.0,
              ),
              Text(
                "  Save Event",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 20,
                  color: Colors.white,
                ),
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
              children: [
            navigation,
            spacer,
            subjectField,
            divider,
            dateField,
            divider,
            startTimeField,
            divider,
            endTimeField,
            divider,
            repeatField,
            divider,
            periodField,
            saveButton
          ])),
    );
  }
}
