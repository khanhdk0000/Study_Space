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
              child:   Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 24.0
              ),
            )

        );
  }
}
