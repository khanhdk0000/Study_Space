import 'package:flutter/material.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/CommonComponents/components.dart';

const divider = SizedBox(height: 32.0);

class CountdownScreen extends StatefulWidget {

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  @override
  var hours = 0;
  var minutes = 45;
  var seconds = 0;

  final pickerTextStyle = TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 60,
      color: Colors.black);


  _displayDialog(BuildContext context, String type) async {
    return showDialog(
        context: context,
        builder: (context) {
          final controller = TextEditingController(text: '');
          return AlertDialog(
            title: Text('Change $type'),
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
                      case "hour": {
                        hours = int.parse(controller.text);
                      }
                      break;

                      case "minute": {
                        minutes = int.parse(controller.text);
                      }
                      break;

                      default: {
                        seconds = int.parse(controller.text);
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
              children: [Navigation, divider])),
    );
  }
}
