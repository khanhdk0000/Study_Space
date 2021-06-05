import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/schedController.dart';
import 'package:study_space/global.dart';

///User arguments
int _userid = user_id;
final User user = auth.currentUser;

const spacer = SizedBox(height: 20.0);

class AddSessionScreen extends StatefulWidget {

  @override
  _AddSessionScreenState createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  @override

  var schedule = schedController();
  var subject = "_";
  var startDate = "06/09/2069";
  var startTime = "00:00:00";
  var endTime = "00:00:00";
  int repeat = 1;
  int period = 1;

  final divider = Container(height: 1.0, color: Colors.black26);

  final bodyText = TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 20,
      color: Colors.black);

  _displayDialog(BuildContext context, String type) async {
    return showDialog(
        context: context,
        builder: (context) {
          var text = "";
          switch(type) {
            case "Event Name": {
              text = subject;
            }
            break;

            case "Start Date": {
              text = startDate;
            }
            break;

            case "Start Time": {
              text = startTime;
            }
            break;

            case "End Time": {
              text = endTime;
            }
            break;

            case "Period": {
              text = period.toString();
            }
            break;

            case "Repeat": {
              text = repeat.toString();
            }
            break;
          }

          final controller = TextEditingController(text: text);
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
                    switch(type) {
                      case "Event Name": {
                        subject = controller.text;
                      }
                      break;

                      case "Start Date": {
                        startDate = controller.text;
                      }
                      break;

                      case "Start Time": {
                        startTime = controller.text;
                      }
                      break;

                      case "End Time": {
                        endTime = controller.text;
                      }
                      break;

                      case "Period": {
                        period = int.parse(controller.text);
                      }
                      break;

                      case "Repeat": {
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
    var Navigation = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ReturnButton(),
          Text("New Study Event", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black),
          )
        ],
      ),
    ]);

    final SubjectField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Event Name"),
            child:   Text(
              "Event name : $subject",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 30,
                  color: Colors.black),
            )
        )
    );

    final DateField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Start Date"),
            child:   Text(
              "Begins on: $startDate",
              textAlign: TextAlign.left,
              style: bodyText,
            ))
    );

    final StartTimeField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Start Time"),
            child:   Text(
              "Start Time: $startTime",
              textAlign: TextAlign.left,
              style: bodyText,
            ))
    );

    final EndTimeField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "End Time"),
            child:   Text(
              "End Time: $endTime",
              textAlign: TextAlign.left,
              style: bodyText,
            ))
    );

    final RepeatField = Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Repeat"),
            child:   Text(
              "Repeat: $repeat times",
              textAlign: TextAlign.left,
              style: bodyText,
            ))
    );

    final PeriodField = Container(
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 24, right: 20),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Period"),
            child:   Text(
              "Repeat every: $period days",
              textAlign: TextAlign.left,
              style: bodyText,
            ))
    );

    final SaveButton =  TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        onPressed: () {
          SessionController().addSessions(repeat, period, startDate, startTime, endTime, subject, _userid, username: user.displayName);
          //schedule.addSession(subject, timeframe);
          Navigator.pop(context);
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
              children: [Navigation, spacer, SubjectField, divider, DateField, divider, StartTimeField, divider, EndTimeField, divider, RepeatField, divider, PeriodField, SaveButton])),
    );
  }
}
