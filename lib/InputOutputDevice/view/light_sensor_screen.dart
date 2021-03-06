import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study_space/InputOutputDevice/state/light_state.dart';
import 'package:study_space/constants.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class LightSensorScreen extends StatelessWidget {
  const LightSensorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LightState lightState = Provider.of<LightState>(context);

    return Column(
      children: [
        LightSensorScreenHeader(),
        SingleChildScrollView(
          child: Column(
            children: [
              CircleGauge(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: lightState.getAppConnectionState ==
                                  MQTTAppConnectionState.disconnected
                              ? Colors.greenAccent
                              : Colors.greenAccent.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          if (lightState.getAppConnectionState ==
                              MQTTAppConnectionState.disconnected) {
                            lightState.setAppConnectionState(
                                MQTTAppConnectionState.connected);
                          }
                        },
                        icon: Icon(
                          Icons.power_settings_new_rounded,
                          color: Colors.indigo,
                          size: 20,
                        ),
                        label: Text(
                          'Connect',
                          style: TextStyle(color: Colors.indigo, fontSize: 18),
                        ),
                      ),
                      width: (MediaQuery.of(context).size.width -
                                  kDefaultPadding * 2) /
                              2 -
                          kDefaultPadding,
                    ),
                    SizedBox(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: lightState.getAppConnectionState ==
                                  MQTTAppConnectionState.connected
                              ? Colors.redAccent
                              : Colors.redAccent.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          if (lightState.getAppConnectionState ==
                              MQTTAppConnectionState.connected) {
                            lightState.setAppConnectionState(
                                MQTTAppConnectionState.disconnected);
                          }
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'Disconnect',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      width: (MediaQuery.of(context).size.width -
                                  kDefaultPadding * 2) /
                              2 -
                          kDefaultPadding,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CircleGauge extends StatefulWidget {
  const CircleGauge({Key key}) : super(key: key);

  @override
  _CircleGaugeState createState() => _CircleGaugeState();
}

class _CircleGaugeState extends State<CircleGauge> {
  // double value = 300;

  @override
  Widget build(BuildContext context) {
    double value = Provider.of<LightState>(context).getValueFromServer;

    return Container(
      child: Center(
        child: SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 1024,
              canRotateLabels: true,
              showFirstLabel: false,
              maximumLabels: 1,
              interval: 150,
              labelsPosition: ElementsPosition.outside,
              labelOffset: 17,
              pointers: <GaugePointer>[
                MarkerPointer(
                  enableAnimation: true,
                  animationType: AnimationType.ease,
                  value: value,
                  markerHeight: 45,
                  markerWidth: 45,
                  markerType: MarkerType.image,
                  imageUrl: 'assets/img/light.png',
                )
              ],
              axisLabelStyle:
                  GaugeTextStyle(fontSize: 15, color: Colors.black54),
              majorTickStyle: MajorTickStyle(
                  length: 0.05,
                  lengthUnit: GaugeSizeUnit.factor,
                  thickness: 1.5,
                  color: Color(0xFFFF7676)),
              minorTickStyle: MinorTickStyle(
                  length: 0.02,
                  lengthUnit: GaugeSizeUnit.factor,
                  thickness: 1.5,
                  color: Color(0xFFF54EA2)),
              axisLineStyle: AxisLineStyle(
                thickness: 22,
                cornerStyle: CornerStyle.bothCurve,
                gradient: const SweepGradient(
                  colors: <Color>[Color(0xFFFF7676), Color(0xFFF54EA2)],
                  stops: <double>[0.25, 0.75],
                ),
              ),
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  horizontalAlignment: GaugeAlignment.center,
                  verticalAlignment: GaugeAlignment.center,
                  widget: Column(
                    children: <Widget>[
                      Container(
                          width: 90.00,
                          height: 90.00,
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image:
                                  ExactAssetImage('assets/img/lightbulb1.png'),
                              fit: BoxFit.fitHeight,
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Container(
                          child: Text(
                            '${value.toStringAsFixed(0)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                      )
                    ],
                  ),
                  angle: 90,
                  axisValue: 5,
                  positionFactor: 0.9,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LightSensorScreenHeader extends StatelessWidget {
  const LightSensorScreenHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        height: 340,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3383CD),
              Color(0xFF11249F),
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  'Lighting Sensor',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: 20,
              child: SvgPicture.asset(
                'assets/img/internet-of-things.svg',
                color: Colors.white54,
                height: 80,
              ),
            ),
            Positioned(
              top: 50,
              left: 10, // ffd166
              child: SvgPicture.asset(
                'assets/img/Light bulb-rafiki.svg',
                width: 350,
                alignment: Alignment.center,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              left: 20,
              top: 45,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        onPressed: () {
          print('go back');
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_outlined, color: Colors.white, size: 24.0),
      ),
    );
  }
}
