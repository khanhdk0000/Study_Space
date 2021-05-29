import 'package:flutter/material.dart';
import 'package:study_space/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
                      // SliderWidget(),
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

// class SliderWidget extends StatefulWidget {
//   const SliderWidget({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   _SliderWidgetState createState() => _SliderWidgetState();
// }
//
// class _SliderWidgetState extends State<SliderWidget> {
//   double _currentSliderValue = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               '0',
//               style:
//                   Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 19),
//             ),
//             Text(
//               _currentSliderValue.toStringAsFixed(3),
//               style:
//                   Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 19),
//             ),
//           ],
//         ),
//         Slider(
//           value: _currentSliderValue,
//           min: 0,
//           max: 100,
//           label: _currentSliderValue.round().toString(),
//           onChanged: (newvalue) {
//             // setState(() {
//             //   _currentSliderValue = newvalue;
//             // });
//           },
//         ),
//       ],
//     );
//   }
// }

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

///////////////////////////////////
class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final thumbHeight;
  final int min;
  final int max;

  const CustomSliderThumbRect({
    this.thumbRadius,
    this.thumbHeight,
    this.min,
    this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: thumbHeight * 1.2, height: thumbHeight * .6),
      Radius.circular(thumbRadius * .4),
    );

    final paint = Paint()
      ..color = sliderTheme.activeTrackColor //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontSize: thumbHeight * .3,
            fontWeight: FontWeight.w700,
            color: sliderTheme.thumbColor,
            height: 1),
        text: '${getValue(value)}');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawRRect(rRect, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}

class SliderWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  SliderWidget(
      {this.sliderHeight = 48,
      this.max = 100,
      this.min = 0,
      this.fullWidth = false});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
      width: this.widget.fullWidth
          ? double.infinity
          : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(
          Radius.circular((this.widget.sliderHeight * .3)),
        ),
        gradient: new LinearGradient(
            colors: [
              const Color(0xFF00c6ff),
              const Color(0xFF0072ff),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.00),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor,
            2, this.widget.sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            Text(
              '${this.widget.min}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: this.widget.sliderHeight * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: this.widget.sliderHeight * .1,
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white.withOpacity(1),
                    inactiveTrackColor: Colors.white.withOpacity(.5),

                    trackHeight: 4.0,
                    thumbShape: CustomSliderThumbCircle(
                      thumbRadius: this.widget.sliderHeight * .4,
                      min: this.widget.min,
                      max: this.widget.max,
                    ),
                    overlayColor: Colors.white.withOpacity(.4),
                    //valueIndicatorColor: Colors.white,
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.red.withOpacity(.7),
                  ),
                  child: Slider(
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      }),
                ),
              ),
            ),
            SizedBox(
              width: this.widget.sliderHeight * .1,
            ),
            Text(
              '${this.widget.max}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: this.widget.sliderHeight * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const CustomSliderThumbCircle({
    @required this.thumbRadius,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
      style: new TextStyle(
        fontSize: thumbRadius * .8,
        fontWeight: FontWeight.w700,
        color: sliderTheme.thumbColor, //Text Color of Value on Thumb
      ),
      text: getValue(value),
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
