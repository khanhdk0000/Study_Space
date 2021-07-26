import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/Controller/sensorController.dart';

class FunkyDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyDialogState();
}

class FunkyDialogState extends State<FunkyDialog>
    with SingleTickerProviderStateMixin {
  SensorController s = SensorController();
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: AlertDialog(
        title: Text('How performance score is calculated?'),
        content: Column(
          children: [
            Image(image: AssetImage('assets/img/calculator.png')),
            Text(s.howEvaluatedText()),
          ],
        ),
        scrollable: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}