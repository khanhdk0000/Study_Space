import 'package:flutter/material.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Schedule/schedule_controller.dart';

const spacer = SizedBox(height: 32.0);

class AddSessionScreen extends StatefulWidget {

  @override
  _AddSessionScreenState createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  @override

  var schedule = Schedule();
  var subject = "Your subject name";
  var timeframe = "Your timeframe";

  final divider = Container(height: 1.0, color: Colors.black26);

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

                      case "Time": {
                        timeframe = controller.text;
                      }
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
          subject,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w100,
              fontSize: 50,
              color: Colors.black),
        ))
    );

    final TimeField = Container(
        padding: EdgeInsets.only(left: 36, top: 36, bottom: 50, right: 36),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Time"),
            child:   Text(
              timeframe,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 50,
                  color: Colors.black),
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
          schedule.addSession(subject, timeframe);
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
              children: [Navigation, spacer, SubjectField, divider, TimeField, SaveButton])),
    );
  }
}
