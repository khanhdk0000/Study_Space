import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/theme.dart';
import 'package:study_space/Quiz/test_selection.dart';
import 'package:study_space/Notification/notification_screen.dart';

class GradeSelectScreen extends StatefulWidget {
  @override
  _GradeSelectPageState createState() => _GradeSelectPageState();
}

class _GradeSelectPageState extends State<GradeSelectScreen> {
  List<String> images = [
    'assets/images/iconSimplexMethod-06.png',
    'assets/images/iconBranchAndBound-06.png',
    'assets/images/iconCuttingPlane-06.png'
  ];

  Widget testOption(String grade, String image) {
    return Container(
      height: 70.0,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        border:
            Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06))),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => TestPage(grade),
          ));
        },
        child: Material(
          color: Colors.white,
          child: ListTile(
            // leading: Image(
            //   image: AssetImage(image),
            //   // height: 50.0,
            // ),
            title: Text(grade, style: TextStyle(fontSize: 15.0)),
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
                  "Grade Selection",
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
    return MaterialApp(
      theme: lightThemeData(context),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SideMenu(),
        body: ListView(
          children: <Widget>[
            Column(
              children: [
                _topView(),
                for (var i in List<int>.generate(3, (i) => i + 1))
                  testOption("Grade " + i.toString(), images[i - 1]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
