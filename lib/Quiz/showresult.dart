import 'package:flutter/material.dart';
// import 'package:numbercrunching/screen/homepage.dart';

// import '../drawer.dart';

class ResultPage extends StatefulWidget {
  int marks;
  ResultPage({Key key, @required this.marks}) : super(key: key);
  @override
  _ResultPageState createState() => _ResultPageState(marks);
}

class _ResultPageState extends State<ResultPage> {
  String message;

  void initState() {
    if (marks < 5) {
      message = "You Should Try Harder Next Time";
    } else if (marks < 8) {
      message = "You Passed This Test";
    } else {
      message = "You Did Very Well";
    }
    super.initState();
  }

  int marks;
  _ResultPageState(this.marks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test', style: TextStyle(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),
      // drawer: DrawTab(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text('YOUR POINT IS',
                        style: TextStyle(
                          fontSize: 50,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent, shape: BoxShape.circle),
                    height: 200.0,
                    width: 200.0,
                    child: Center(
                      child: Text('$marks',
                          style: TextStyle(
                            fontSize: 60,
                          )),
                    ),
                  ),
                  Center(
                    child: Text(message,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
