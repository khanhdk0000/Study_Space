import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/Session.dart';

class SessionsView extends StatefulWidget {
  const SessionsView({Key key}) : super(key: key);

  @override
  _SessionsViewState createState() => _SessionsViewState();
}

class _SessionsViewState extends State<SessionsView> {
  Future<List<Session>> futureSession;
  int _numView = 5;
  int _sortedBy = 0;
  String _username = 'Gwen';
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
      body: Text("text"),
    );
  }
}