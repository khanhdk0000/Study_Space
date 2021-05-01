import 'package:flutter/material.dart';
import 'package:study_space/Home/view/SideMenu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SideMenu(),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
