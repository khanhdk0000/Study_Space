import 'package:flutter/material.dart';
import 'package:study_space/constants.dart';

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({Key key, @required this.child}) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      padding: EdgeInsets.symmetric(
        vertical: kDefaultPadding / 4,
        horizontal: kDefaultPadding,
      ),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(25),
      ),
      child: child,
    );
  }
}
