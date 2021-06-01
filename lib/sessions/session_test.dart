import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/session.dart';
import 'package:study_space/global.dart';
import 'package:study_space/Controller/schedController.dart';

User user = FirebaseAuth.instance.currentUser;

class SessionsView extends StatefulWidget {
  const SessionsView({Key key}) : super(key: key);

  @override
  _SessionsViewState createState() => _SessionsViewState();
}

class _SessionsViewState extends State<SessionsView> {
  Future<List<Session>> futureSession;
  int _numView = 5;
  int _sortedBy = 0;
  String _username = user.displayName;
  int _progress = 75;
  List<String> _numViewValue = ['1', '2', '5', '10', '25', '99'];
  List<String> _sortSelection = [
    'Score (H)',
    'Score (L)',
    'Name (A-Z)',
    'Name (Z-A)',
    'Time (H)',
    'Time (L)'
  ];

  @override
  void initState() {
    super.initState();
    // futureSession = SessionController().getAllSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            _topView(context),
            ElevatedButton(onPressed: addSes, child: Text("add session")),
            Text("data"),
          ],
        ),
      ),
    );
  }

  Widget _topView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
          child: Row(
            children: [
              Column(
                children: [
                  MenuButton(),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {},
                    child: Icon(Icons.refresh, color: Colors.black, size: 24.0),
                  ),
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/img/portrait.png'),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _username,
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
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.black38),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addSes() {
    var c = new SessionController();
    c.getCurrentSession('user');
  }
}
