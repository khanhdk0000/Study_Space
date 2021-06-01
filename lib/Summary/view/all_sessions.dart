<<<<<<< HEAD
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/Session.dart';
import 'package:study_space/summary/view/one_session.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/session.dart';
import 'package:study_space/Summary/view/one_session.dart';
>>>>>>> main

class SummaryAllSessionsView extends StatefulWidget {
  const SummaryAllSessionsView({Key key}) : super(key: key);

  @override
  _SummaryAllSessionsViewState createState() => _SummaryAllSessionsViewState();
}

class _SummaryAllSessionsViewState extends State<SummaryAllSessionsView> {
<<<<<<< HEAD
  Future<List<Session>> futureSession;
  int _numView = 5;
  int _sortedBy = 0;
  String _username = 'Gwen';
  int _progress = 75;
  List<String> _numViewValue = ['1', '2', '5', '10', '25', '99'];
  List<String> _sortSelection = ['Score (H)', 'Score (L)', 'Name (A-Z)', 'Name (Z-A)', 'Time (H)', 'Time (L)'];

  @override
  void initState() {
    super.initState();
    futureSession = SessionController().getAllSessions();
  }

  @override
  Widget build(BuildContext context) {
=======
  ///Argument to store list of sessions
  Future<List<Session>> futureSession;

  ///Sorting arguments and selections
  int _numView = 5;
  int _sortedBy = 0;
  List<String> _numViewValue = ['1', '2', '5', '10', '25', '99'];
  List<String> _sortSelection = [
    'Score (H)',
    'Score (L)',
    'Name (A-Z)',
    'Name (Z-A)',
    'Time (H)',
    'Time (L)'
  ];

  ///User arguments
  String _username = "Gwen";
  int _userid = 13;
  int _progress = 75;
  final User user = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    //Retrieve data from the database through SessionController.
    futureSession = SessionController().getAllSessions(_userid,
        SessionController().setFilter(_sortSelection[_sortedBy]), _numView);
>>>>>>> main
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            _topView(context),
            SizedBox(height: kDefaultPadding),
            _sortView(context),
            SizedBox(height: kDefaultPadding),
            _listView(context),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _topView(BuildContext context){
=======
  Widget _topView(BuildContext context) {
>>>>>>> main
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: Center(
        child: Padding(
<<<<<<< HEAD
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
=======
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
>>>>>>> main
          child: Row(
            children: [
              Column(
                children: [
                  MenuButton(),
                  TextButton(
                    style: ButtonStyle(
<<<<<<< HEAD
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
=======
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
>>>>>>> main
                    ),
                    onPressed: () {},
                    child: Icon(Icons.refresh, color: Colors.black, size: 24.0),
                  ),
                ],
              ),
<<<<<<< HEAD
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05
              ),
=======
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
>>>>>>> main
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/img/portrait.png'),
              ),
<<<<<<< HEAD
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05
              ),
=======
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
>>>>>>> main
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
<<<<<<< HEAD
                    _username,
=======
                    user == null ? _username : user.displayName,
>>>>>>> main
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(height: kDefaultPadding * 0.2),
                  Text(
                    "$_progress% study goal\ncompleted",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
<<<<<<< HEAD
                        fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black38),
=======
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.black38),
>>>>>>> main
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _sortView(BuildContext context){
    return Container(
      color: Colors.black,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _whiteText('Your last study sessions:'),
            SizedBox(height: kDefaultPadding * 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _whiteText('Show'),
                _dropDownNumView(context),
                _whiteText('Sorted by:'),
                _dropDownSort(context),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _listView(BuildContext context){
=======
  Widget _sortView(BuildContext context) {
    return Container(
        color: Colors.black,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _whiteText('Your last study sessions:'),
              SizedBox(height: kDefaultPadding * 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _whiteText('Show'),
                  _dropDownNumView(context),
                  _whiteText('Sorted by:'),
                  _dropDownSort(context),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _listView(BuildContext context) {
>>>>>>> main
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
<<<<<<< HEAD
          child: FutureBuilder(future: futureSession, builder: (context, snapshot){
            if (snapshot.hasData){
              var numDisplay = snapshot.data.length > _numView ? _numView : snapshot.data.length;
              List<Widget> widLst = [];
              for(int i = 0; i < numDisplay; i++){
                print(snapshot.data[i].displaySession());
                widLst.add(_scheduleTile(snapshot.data[i].displaySession()));
              }
              return Column(
                children: widLst,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Text('Loading...');
          }),
=======
          child: FutureBuilder(
              future: futureSession,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var numDisplay = snapshot.data.length > _numView
                      ? _numView
                      : snapshot.data.length;
                  List<Widget> widLst = [];
                  for (int i = 0; i < numDisplay; i++) {
                    print(snapshot.data[i].displaySession());
                    widLst
                        .add(_scheduleTile(snapshot.data[i].displaySession()));
                  }
                  return Column(
                    children: widLst,
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Text('Loading...');
              }),
>>>>>>> main
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _whiteText(String text){
=======
  Widget _whiteText(String text) {
>>>>>>> main
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
<<<<<<< HEAD
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white),
    );
  }

  Widget _dropDownNumView(BuildContext context){
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
          borderRadius: new BorderRadius.all(Radius.circular(6.0))
      ),
=======
          fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white),
    );
  }

  Widget _dropDownNumView(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
          borderRadius: new BorderRadius.all(Radius.circular(6.0))),
>>>>>>> main
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 5.0),
        child: DropdownButton(
          value: _numView.toString(),
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          underline: Container(
            height: 2.0,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              _numView = int.parse(newValue);
            });
          },
<<<<<<< HEAD
          items: _numViewValue.map<DropdownMenuItem<String>>((String value){
=======
          items: _numViewValue.map<DropdownMenuItem<String>>((String value) {
>>>>>>> main
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _dropDownSort(BuildContext context){
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
          borderRadius: new BorderRadius.all(Radius.circular(6.0))
      ),
=======
  Widget _dropDownSort(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
          borderRadius: new BorderRadius.all(Radius.circular(6.0))),
>>>>>>> main
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 5.0),
        child: DropdownButton(
          value: _sortSelection[_sortedBy],
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          underline: Container(
            height: 2.0,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              _sortedBy = _sortSelection.indexOf(newValue);
            });
          },
<<<<<<< HEAD
          items: _sortSelection.map<DropdownMenuItem<String>>((String value){
=======
          items: _sortSelection.map<DropdownMenuItem<String>>((String value) {
>>>>>>> main
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _scheduleTile(List<String> oneScheduleList){
=======
  Widget _scheduleTile(List<String> oneScheduleList) {
>>>>>>> main
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        focusColor: Colors.grey,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OneSessionView(sessionList: oneScheduleList),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 90.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 23,
                spreadRadius: -13,
                color: kShadowColor.withOpacity(0.24),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      oneScheduleList[0],
                      style: TextStyle(
<<<<<<< HEAD
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
=======
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
>>>>>>> main
                      ),
                    ),
                    Text(
                      oneScheduleList[1],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
<<<<<<< HEAD
                    Text(
                      oneScheduleList[2],
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54,
                      )
                    )
=======
                    Text(oneScheduleList[2],
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.black54,
                        ))
>>>>>>> main
                  ],
                ),
                _circleScore(oneScheduleList[3])
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleScore(String score) {
<<<<<<< HEAD
    return Container(
                alignment: Alignment.center,
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: _circleColor(int.parse(score)),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  score,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white,
                  )
                )
              );
  }

  MaterialAccentColor _circleColor(int score){
    if (score == 100.0){
      return Colors.greenAccent;
    }
    else if (score >= 70.0){
      return Colors.orangeAccent;
    }
    else {
      return Colors.redAccent;
    }
  }

=======
    String scoreText = (score == '-99') ? 'NA' : score;
    return Container(
        alignment: Alignment.center,
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: _circleColor(int.parse(score)),
          shape: BoxShape.circle,
        ),
        child: Text(scoreText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white,
            )));
  }

  Color _circleColor(int score) {
    if (score == 100.0) {
      return Colors.greenAccent;
    } else if (score >= 70.0) {
      return Colors.orangeAccent;
    } else if (score > 0) {
      return Colors.redAccent;
    } else {
      return Colors.grey;
    }
  }
>>>>>>> main
}
