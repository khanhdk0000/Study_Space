import 'package:flutter/material.dart';
import 'package:study_space/Home/view/side_menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SideMenu(),
      body: SafeArea(
        child: Container(
          child: ElevatedButton(
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            onPressed: () { },
            child: Text('Button'),
          ),
        ),
      ),
    );
  }
}
