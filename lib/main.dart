import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_space/Authentication/screen/welcome_screen.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/InputOutputDevice/state/buzzer_state.dart';
import 'package:study_space/InputOutputDevice/state/lcd_state.dart';
import 'package:study_space/InputOutputDevice/state/light_state.dart';
import 'package:study_space/InputOutputDevice/state/sound_state.dart';
import 'package:study_space/InputOutputDevice/state/temp_state.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

User user = FirebaseAuth.instance.currentUser;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent, // status bar color
  ));
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

  runApp(App());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LightState>(
          create: (_) => LightState(),
          lazy: false,
        ),
        ChangeNotifierProvider<TempState>(
          create: (_) => TempState(),
          lazy: false,
        ),
        ChangeNotifierProvider<SoundState>(
          create: (_) => SoundState(),
          lazy: false,
        ),
        ChangeNotifierProvider<BuzzerState>(
          create: (_) => BuzzerState(),
          lazy: false,
        ),
        ChangeNotifierProvider<LCDState>(
          create: (_) => LCDState(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        home: user == null ? WelcomeScreen() : HomeScreen(),
        routes: {
          kHomeScreen: (BuildContext context) => HomeScreen(),
          kWelcomeScreen: (BuildContext context) => WelcomeScreen(),
        },
      ),
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
