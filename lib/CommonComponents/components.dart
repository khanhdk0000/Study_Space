import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        child: Icon(Icons.menu, color: Colors.black, size: 24.0),
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
          child:   Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24.0
          ),
        )

    );
  }
}

const colors = [Colors.blue, Colors.amber, Colors.green, Colors.lime, Colors.orange, Colors.purple, Colors.red];
final divider = Container(height: 1.0, color: Colors.black26);