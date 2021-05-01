import 'package:flutter/material.dart';
import 'package:study_space/Home/view/HomeScreen.dart';
import 'package:study_space/Sensor/view/LightingSensor_screen.dart';
import 'package:study_space/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: ClipRect(
              child: Container(
                child: Align(
                  heightFactor: 0.6,
                  child: Image.asset('assets/img/Studying-pana.png'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          Expanded(
            child: ListView(
              children: [
                CardWidget(
                  name: 'Lighting',
                  unit: 'Lux',
                  img: 'assets/img/creativity.svg',
                  color: Color(0xFF2F4357),
                ),
                CardWidget(
                  name: 'Sound',
                  unit: 'dB',
                  img: 'assets/img/speaker.svg',
                  color: Color(0xFFBDB2FF),
                ),
                CardWidget(
                  name: 'Temperature',
                  unit: '\u1d52C',
                  img: 'assets/img/thermometer.svg',
                  color: Color(0xFFF6BD60),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key key,
    @required this.name,
    @required this.unit,
    @required this.img,
    @required this.color,
  }) : super(key: key);

  final String name;
  final String unit;
  final String img;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              switch (name) {
                case 'Lighting':
                  return LightingSensorScreen();
                  break;
                default:
                  return HomeScreen();
              }
            },
          ),
        ),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 23,
                spreadRadius: -13,
                color: kShadowColor.withOpacity(0.24),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                child: SvgPicture.asset(
                  img,
                ),
                padding: EdgeInsets.all(8),
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: color,
                ),
              ),
              SizedBox(
                width: kDefaultPadding,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Threshold: 400 ' + unit,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.navigate_next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
