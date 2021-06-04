import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/schedController.dart';


///User arguments
String _username = "Gwen";
int _userid = 2;
int _progress = 75;
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
  int repeat = 0;
  int period = 1;

  final divider = Container(height: 1.0, color: Colors.black26);

  final bodyText = TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 24,
      color: Colors.black);

  _displayDialog(BuildContext context, String type) async {
    return showDialog(
        context: context,
        builder: (context) {
          final controller = TextEditingController(text: '');
          return AlertDialog(
            title: Text('$type'),
            content: TextField(
              controller: controller,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.numberWithOptions(),
            ),
            actions: <Widget>[
              TextButton(
                child: new Text('Ok'),
                onPressed: () {
                  setState(() {
                    switch(type) {
                      case "Subject": {
                        subject = controller.text;
                      }
                      break;

                      case "Date": {
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
          Text("New Session", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black),
          )
        ],
      ),
    ]);

    final SubjectField = Container(
      padding: EdgeInsets.all(36),
      color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
      child:TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        onPressed: ()  => _displayDialog(context, "Subject"),
        child:   Text(
          "Your session name is $subject",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w100,
              fontSize: 50,
              color: Colors.black),
        ))
    );

    final DateField = Container(
        padding: EdgeInsets.all(36),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Date"),
            child:   Text(
              "This session begins on $startDate",
              textAlign: TextAlign.left,
              style: bodyText,
            ))
    );

    final TimeField = Container(
        padding: EdgeInsets.all(36),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: ()  => _displayDialog(context, "Start Time"),
                child:   Text(
                  "This session starts from $startTime",
                  textAlign: TextAlign.left,
                  style: bodyText,
                )),
            TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: ()  => _displayDialog(context, "End Time"),
                child:   Text(
                  "to $endTime",
                  textAlign: TextAlign.left,
                  style: bodyText,
                )),
          ],
        )
    );

    final RepeatField = Container(
        padding: EdgeInsets.all(36),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Repeat"),
            child:   Text(
              "This session repeats $repeat times",
              textAlign: TextAlign.left,
              style: bodyText,
            ))
    );

    final PeriodField = Container(
        padding: EdgeInsets.only(left: 36, top: 36, bottom: 50, right: 36),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Period"),
            child:   Text(
              "This session repeats every $period days",
              textAlign: TextAlign.left,
              style: bodyText,
            ))
    );

    final SaveButton =  TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // <-- Radius
          ),
        ),
        onPressed: () {
          SessionController().addSessions(repeat, period, startDate, startTime, endTime, subject, _userid);
          //schedule.addSession(subject, timeframe);
          Navigator.pop(context);
        },
        child:   Container(
          padding: EdgeInsets.only(left: 36, top: 18, bottom: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 22.0,
              ),
              Text(
                "  Save Session",
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
              children: [Navigation, spacer, SubjectField, divider, DateField, divider, TimeField, divider, RepeatField, divider, PeriodField, SaveButton])),
    );
  }
}
