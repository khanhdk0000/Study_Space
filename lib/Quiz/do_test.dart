import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Quiz/showresult.dart';
// import 'package:study_space/Quiz/drawer.dart';
// import '../drawer.dart';

class CreateQuestion extends StatelessWidget {
  String method;

  CreateQuestion(this.method);

  String methodChosen;

  setasset() {
    if (method == 'Simplex Method') {
      methodChosen = 'assets/json/grade1/simplex.json';
    } else if (method == 'Branch And Bound Method') {
      methodChosen = 'assets/json/grade1/branch.json';
    } else if (method == 'Cutting Plane Method') {
      methodChosen = 'assets/json/grade1/cutting.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    setasset();
    print('here: ' + methodChosen);
    return FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString(methodChosen, cache: true),
      builder: (context, snapshot) {
        List question = json.decode(snapshot.data.toString());
        if (question == null) {
          return Scaffold(
            body: Center(
              child: Text(
                'Loading',
              ),
            ),
          );
        } else {
          return QuizPage(question: question);
        }
      },
    );
  }
}

class QuizPage extends StatefulWidget {
  var question;

  QuizPage({Key key, @required this.question}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState(question);
}

class _QuizPageState extends State<QuizPage> {
  var question;

  _QuizPageState(this.question);

  Color right = Colors.green;
  Color wrong = Colors.red;
  Color selected = Colors.grey;
  int marks = 0;
  int i = 1;
  int j = 1;
  List<String> savedAnswer = List<String>.generate(10, (index) => null);
  bool cancelTimer = false;
  var randomArray;

  Map<String, Color> btncolor = {
    'a': Colors.blue,
    'b': Colors.blue,
    'c': Colors.blue,
    'd': Colors.blue,
  };

  genRandomArray() {
    var distinctIds = [];
    var rand = new Random();
    for (int i = 0;;) {
      int number;
      number = rand.nextInt(10) + 1;
      distinctIds.add(number);
      randomArray = distinctIds.toSet().toList();
      if (randomArray.length < 10) {
        continue;
      } else {
        break;
      }
    }
    print(randomArray);
  }

  @override
  void initState() {
    startTimeout();
    genRandomArray();
    i = randomArray[0];
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          cancelTimer = true;
          j = 10;
          submit();
        }
      });
    });
  }

  void nextQuestion() {
    setState(() {
      if (j < 10) {
        i = randomArray[j];
        j++;
      }

      btncolor['a'] = Colors.blue;
      btncolor['b'] = Colors.blue;
      btncolor['c'] = Colors.blue;
      btncolor['d'] = Colors.blue;
    });
  }

  void checkAnswer(String answer) {
    if (question[2][i.toString()] == question[1][i.toString()][answer] &&
        answer != savedAnswer[j - 1]) {
      marks = marks + 1;
    }

    setState(() {
      btncolor[answer] = Colors.grey;
      btncolor[savedAnswer[j - 1]] = Colors.blue;
      cancelTimer = true;
    });
    savedAnswer[j - 1] = answer;
    print(savedAnswer);
    // changed timer duration to 1 second
    Timer(Duration(seconds: 1), nextQuestion);
  }

  Widget selectAnswer(String answer) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkAnswer(answer),
        child: Text(question[1][i.toString()][answer],
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            )),
        color: btncolor[answer],
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  void changeQuestion(int index) {
    setState(() {
      i = randomArray[index];
      j = index + 1;
      btncolor['a'] = Colors.blue;
      btncolor['b'] = Colors.blue;
      btncolor['c'] = Colors.blue;
      btncolor['d'] = Colors.blue;

      if (savedAnswer[index] != null) {
        btncolor[savedAnswer[index]] = selected;
      }
    });
  }

  void submit() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => ResultPage(marks: marks),
    ));
  }

  Widget questionsList() {
    return Wrap(
      children: [
        for (var i in List<int>.generate(10, (i) => i + 1))
          ElevatedButton(
            onPressed: () => changeQuestion(i - 1),
            child: Text(i.toString()),
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow, // background
              onPrimary: Colors.black, // foreground
            ),
          ),
        ElevatedButton(
          onPressed: () => submit(),
          child: Text('Submit'),
          style: ElevatedButton.styleFrom(
            primary: Colors.pink, // background
            onPrimary: Colors.black, // foreground
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test', style: TextStyle(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          questionsList(),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.centerLeft,
              child: Text(
                question[0][i.toString()],
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  selectAnswer('a'),
                  selectAnswer('b'),
                  selectAnswer('c'),
                  selectAnswer('d'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              child: Center(
                child: Text(
                  timerText,
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
