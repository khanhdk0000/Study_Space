import 'package:flutter/material.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/theme.dart';

import 'package:study_space/mqtt/MQTTView.dart';
import 'package:study_space/mqtt/state/MQTTAppState.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      home: ChangeNotifierProvider<MQTTAppState>(
        create: (_) => MQTTAppState(),
        child: MQTTView(),
      ),
    );
  }
}
