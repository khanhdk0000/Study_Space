import 'package:flutter/material.dart';
import 'package:study_space/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

class LightingSensorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.5),
            child: Column(
              children: [
                Stack(
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
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lighting',
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(color: Colors.black87),
                  ),
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 55,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          SizedBox(
                            width: kDefaultPadding / 2,
                          ),
                          Text(
                            'On/off',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 27, color: Colors.black87),
                          ),
                          Spacer(),
                          SwitchButton(),
                        ],
                      ),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 55,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          SizedBox(
                            width: kDefaultPadding / 2,
                          ),
                          Text(
                            'Set Value',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 27, color: Colors.black87),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      SliderWidget(),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 55,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          SizedBox(
                            width: kDefaultPadding / 2,
                          ),
                          Text(
                            'Real time value',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 27, color: Colors.black87),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 55,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          SizedBox(
                            width: kDefaultPadding / 2,
                          ),
                          Text(
                            'Lighting threshold',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 27, color: Colors.black87),
                          ),
                          Spacer(),
                          DropdownWidget(),
                        ],
                      ),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({
    Key key,
  }) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: () {});
  }
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({
    Key key,
  }) : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 19),
            ),
            Text(
              _currentSliderValue.toStringAsFixed(3),
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 19),
            ),
          ],
        ),
        Slider(
          value: _currentSliderValue,
          min: 0,
          max: 100,
          label: _currentSliderValue.round().toString(),
          onChanged: (newvalue) {
            setState(() {
              _currentSliderValue = newvalue;
            });
          },
        ),
      ],
    );
  }
}

class SwitchButton extends StatefulWidget {
  const SwitchButton({
    Key key,
  }) : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterSwitch(
        width: 80,
        height: 40.0,
        valueFontSize: 13.0,
        toggleSize: 25.0,
        value: status,
        borderRadius: 30.0,
        padding: 8.0,
        showOnOff: true,
        onToggle: (value) {
          setState(() {
            status = value;
          });
        },
      ),
    );
  }
}
