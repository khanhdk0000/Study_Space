import 'package:flutter/material.dart';
import 'package:study_space/Quiz/do_test.dart';
import 'package:study_space/Quiz/variables.dart';

import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/theme.dart';


class TestPage extends StatefulWidget {
  String method;
  TestPage(this.method);
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  

  List<String> tempList;

  getGrade() {
    switch (widget.method) {
      case 'Grade 1': {tempList = grade1;} break;
      case 'Grade 2': {tempList = grade2;} break;
      case 'Grade 3': {tempList = grade3;} break;
    }
  }

  Widget testOption(String method, String image, String description) {
    print(widget.method);
    return Container(
      height: 100.0,
      margin: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => CreateQuestion(method),
          ));
        },
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: ListTile(
            leading: Image(
              image: AssetImage(image),
              height: 100.0,
            ),
            title: Text(method, style: TextStyle(fontSize: 15.0)),
            subtitle: Text(description,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w100,
                    fontSize: 11.0)),
            trailing: Icon(Icons.navigate_next),
          ),
        ),
      ),
    );
  }

  Widget _topView() {
    ///The top view include the drawer button and screen name.
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
          child: Row(
            children: [
              MenuButton(),
              Expanded(
                child: Text(
                  "Test Selection",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(width: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getGrade();
    return MaterialApp(
      theme: lightThemeData(context),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SideMenu(),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                _topView(),
                for (var i in List<int>.generate(3, (i) => i + 1))
                  testOption(tempList[i - 1], images[i - 1], description[i - 1]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
