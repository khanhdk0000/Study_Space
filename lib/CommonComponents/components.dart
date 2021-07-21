import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        child: Icon(Icons.menu, color: Colors.white, size: 24.0),
      ),
    );
  }
}

class CircleMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        child: Container(
          height: 50.0,
          width: 50.0,
          child: Icon(Icons.menu, color: Colors.white, size: 24.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class ReturnButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Icon(Icons.arrow_back, color: Colors.black, size: 24.0),
    ));
  }
}

final loadingIndicator = Container(
    color: Color.fromRGBO(0, 0, 0, 0.06),
    padding: EdgeInsets.all(30),
    child: Icon(
      Icons.hourglass_bottom,
      color: Colors.black,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ));

const colors = [
  Colors.blue,
  Colors.amber,
  Colors.green,
  Colors.lime,
  Colors.orange,
  Colors.purple,
  Colors.red
];
final divider = Container(height: 1.0, color: Colors.black26);
