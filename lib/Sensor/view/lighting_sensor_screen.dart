import 'package:flutter/material.dart';
import 'package:study_space/Sensor/controller/MQTTController.dart';
import 'package:study_space/Sensor/state/light_state.dart';
import 'package:study_space/Sensor/view/custom_slider.dart';
import 'package:study_space/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:study_space/mqtt/MQTTManager.dart';
import 'dart:math';
import 'package:study_space/Controller/sensor_controller.dart';

final _random = new Random();

class LightingSensorScreen extends StatefulWidget {
  @override
  _LightingSensorScreenState createState() => _LightingSensorScreenState();
}

class _LightingSensorScreenState extends State<LightingSensorScreen> {
  MQTTManager manager;
  SensorController sensorController = SensorController();

  @override
  Widget build(BuildContext context) {
    final MQTTLightState lightState = Provider.of<MQTTLightState>(context);

    void connectAdaServer() {
      manager = MQTTManager(
          host: 'io.adafruit.com',
          topic: 'khanhdk0000/feeds/sensor',
          identifier: _random.nextInt(10).toString(),
          state: lightState);
      manager.initializeMQTTClient();
      manager.connect();
    }

    void disconnectAdaServer() {
      manager.disconnect();
    }

    String prepareStateMessageFrom(MQTTAppConnectionState state) {
      switch (state) {
        case MQTTAppConnectionState.connected:
          return 'Connected';
        case MQTTAppConnectionState.connecting:
          return 'Connecting';
        case MQTTAppConnectionState.disconnected:
          return 'Disconnected';
      }
    }

    Widget connectionStateDisplay(String status) {
      Color color;
      if (status == 'Connected') {
        color = Colors.greenAccent;
      } else if (status == 'Disconnected') {
        color = Colors.redAccent;
      } else {
        color = Colors.orangeAccent;
      }
      return Row(
        children: <Widget>[
          Container(
              width: 20,
              height: 20,
              color: color,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Text(status, textAlign: TextAlign.center),
              )),
        ],
      );
    }

    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.5),
            child: Column(
              children: [
                TopSensorScreen(),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: [
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
                    connectionStateDisplay(prepareStateMessageFrom(
                        lightState.getAppConnectionState))
                  ],
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
                            'Connect',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 27, color: Colors.black87),
                          ),
                          Spacer(),
                          SwitchButton(
                            lightState: lightState,
                            connect: connectAdaServer,
                            disconnect: disconnectAdaServer,
                          ),
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
                      // TextButton(
                      //     onPressed: () {
                      //       sensorController.addSensorField(
                      //           name: 'Light',
                      //           unit: 'L1',
                      //           type: 'L',
                      //           timestamp: '2021-01-01 17:00:56',
                      //           sess_id: '1',
                      //           data: '109');
                      //     },
                      //     child: Text('Send'))
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

/////////////////////////////////////

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

class SwitchButton extends StatefulWidget {
  const SwitchButton({
    Key key,
    @required this.lightState,
    @required this.connect,
    @required this.disconnect,
  }) : super(key: key);

  final MQTTLightState lightState;
  final Function connect;
  final Function disconnect;

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    MQTTLightState state = Provider.of<MQTTLightState>(context);
    if (state.getAppConnectionState == MQTTAppConnectionState.connected) {
      status = true;
    }

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
            if (status == true) {
              this.widget.connect();
            } else {
              this.widget.disconnect();
            }
          });
        },
      ),
    );
  }
}
