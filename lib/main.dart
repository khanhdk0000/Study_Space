import 'package:flutter/material.dart';
import 'package:study_space/Authentication/log_in_screen_test.dart';
import 'package:study_space/Authentication/screen/welcome_screen.dart';
import 'package:study_space/Custom/view/custom.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/theme.dart';
import 'package:study_space/mqtt/MQTTView.dart';
import 'package:study_space/mqtt/state/MQTTAppState.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      home: LogInScreen(),
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
        body: Text(text),
      ),
    );
  }
}

