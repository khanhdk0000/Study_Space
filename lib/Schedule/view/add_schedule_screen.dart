import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Controller/schedController.dart';


///User arguments
String _username = "Gwen";
int _userid = 13;
int _progress = 75;
final User user = auth.currentUser;



const spacer = SizedBox(height: 32.0);

class AddScheduleScreen extends StatefulWidget {

  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  @override

  var date = "_";
  var rep = 0;
  var period = 0;
  var startTime = "_";
  var endTime = "_";

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
                      case "Date": {
                        date = controller.text;
                      }
                      break;

                      case "Period": {
                        period = int.parse(controller.text);
                      }
                      break;

                      case "Repeat": {
                        rep = int.parse(controller.text);
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
          Text("New Date Schedule", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black),
          )
        ],
      ),
    ]);

    final DateField = Container(
        padding: EdgeInsets.only(left: 36, top: 36, bottom: 50, right: 36),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Date"),
            child:   Text(
              "Date: $date",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 50,
                  color: Colors.black),
            ))
    );

    final PeriodField = Container(
        padding: EdgeInsets.all(36),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Period"),
            child:   Text(
              "This schedule repeats every $period days",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 30,
                  color: Colors.black),
            ))
    );

    final RepeatCountField = Container(
        padding: EdgeInsets.all(36),
        color: Color.fromRGBO(0, 0, 0, 0.06),
        alignment: Alignment.topLeft,
        child:TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: ()  => _displayDialog(context, "Repeat"),
            child:   Text(
              "This schedule repeat $rep times",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 30,
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
          schedController().addSched(rep, period, date, startTime, endTime, _userid);
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
                "  Save schedule",
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
              children: [Navigation, spacer, DateField, divider, PeriodField, divider, RepeatCountField, SaveButton])),
    );
  }
}
