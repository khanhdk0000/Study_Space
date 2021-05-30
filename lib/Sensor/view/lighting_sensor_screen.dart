import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_space/Sensor/state/light_state.dart';
import 'package:study_space/Sensor/view/custom_slider.dart';
import 'package:study_space/Sensor/view/switch_button.dart';
import 'package:study_space/Sensor/view/top_sensor_screen_part.dart';
import 'package:study_space/constants.dart';
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
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
        child: Container(
            width: 20,
            height: 20,
            // color: color,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: Text('', textAlign: TextAlign.center)),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      TextButton(
                        onPressed: () {
                          final f = DateFormat('yyyy-MM-dd hh:mm:ss');
                          print(DateTime.now());
                          print(f.format(DateTime.now()));
                        },
                        child: Text(
                          'test',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
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
