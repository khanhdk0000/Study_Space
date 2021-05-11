import 'package:flutter/material.dart';
import 'package:study_space/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.size,
    @required this.text,
    @required this.press,
    this.color = kPrimaryColor,
    this.textColor = kContentColorDarkTheme,
  }) : super(key: key);

  final Size size;
  final String text;
  final Function press;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 2, horizontal: kDefaultPadding * 2),
      child: Container(
        width: size.width * 0.8,
        height: 50,
        child: TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: color,
            primary: kContentColorDarkTheme,
            onSurface: Colors.red,
          ),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(fontSize: 18, color: textColor),
          ),
        ),
      ),
    );
  }
}
