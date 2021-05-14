import 'package:flutter/material.dart';
import 'package:study_space/Authentication/screen/welcome_screen.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/theme.dart';

import 'package:study_space/mqtt/MQTTView.dart';
import 'package:study_space/mqtt/state/MQTTAppState.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:study_space/Controller/userController.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TestApp(text: 'hello'));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      home: WelcomeScreen(),
      routes: {
        kHomeScreen: (BuildContext context) => HomeScreen(),
        kWelcomeScreen: (BuildContext context) => WelcomeScreen(),
      },
    );
  }
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return TestApp(text: 'wrong');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return TestApp(text: 'loading');
      },
    );
  }
}

class Ada extends StatelessWidget {
  const Ada({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MQTTAppState>(
      create: (_) => MQTTAppState(),
      child: MQTTView(),
    );
  }
}

class TestApp extends StatelessWidget {
  const TestApp({Key key, @required this.text}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      home: Scaffold(
        body: Center(
          child:
            TestClass(),
        ),
      ),
    );
  }
}

class TestClass extends StatelessWidget {
  String s = 'T';
  var c = new userController();

  Future<void> func() async {
    this.s = await c.testSql();
    this.s = "BB";
  }
  @override
  Widget build(BuildContext context)  {
    return new FutureBuilder(
        // future: getTextFromFile(),
        future: c.testSql(),
        initialData: "Loading text..",
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return new Text(text.data);
        }
    );
  }
}


Future<String> getFileData(String path) async {
  return await new Future(() => "test Text");
}

Future<String> getTextFromFile() async {
  return getFileData("test.txt");
}
