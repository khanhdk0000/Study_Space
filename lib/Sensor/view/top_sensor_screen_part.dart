import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study_space/constants.dart';

class TopSensorScreen extends StatelessWidget {
  const TopSensorScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 210,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF2F4357),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Container(
            child: SvgPicture.asset(
              'assets/img/creativity.svg',
            ),
            padding: EdgeInsets.all(10),
          ),
        ),
        Positioned(
          left: 0,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: kContentColorDarkTheme,
          ),
        )
      ],
    );
  }
}
