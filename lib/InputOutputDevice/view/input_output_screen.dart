import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/InputOutputDevice/controller/buzzer_controller.dart';
import 'package:study_space/InputOutputDevice/controller/light_controller.dart';
import 'package:study_space/InputOutputDevice/controller/temp_controller.dart';
import 'package:study_space/InputOutputDevice/sensor_card.dart';
import 'package:study_space/InputOutputDevice/sensor_notification.dart';
import 'package:study_space/InputOutputDevice/state/temp_state.dart';
import 'package:study_space/InputOutputDevice/view/sensor_screen_header.dart';
import 'package:study_space/InputOutputDevice/state/buzzer_state.dart';
import 'package:study_space/InputOutputDevice/state/light_state.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'package:study_space/OutputDevice/custom_card.dart';
import 'package:study_space/OutputDevice/devicesize.dart';
import 'package:study_space/constants.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:convert';

final _random = new Random();

class Message {
  String id;
  String name;
  String data;
  String unit;

  Message({this.id, this.name, this.data, this.unit});

  Map toJson() => {'id': id, 'name': name, 'data': data, 'unit': unit};
}

class InputOutputScreen extends StatelessWidget {
  const InputOutputScreen({Key key}) : super(key: key);

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
    return Column(
      children: [
        SensorScreenHeader(),
        CustomScrollSensorList(),
      ],
    );
  }
}

class CustomScrollSensorList extends StatefulWidget {
  const CustomScrollSensorList({
    Key key,
  }) : super(key: key);

  @override
  _CustomScrollSensorListState createState() => _CustomScrollSensorListState();
}

class _CustomScrollSensorListState extends State<CustomScrollSensorList> {
  SlidingCardController controller;
  SlidingCardController controller2;
  LightController lightController;
  BuzzerController buzzerController;
  TempController tempController;

  @override
  void initState() {
    super.initState();
    controller = SlidingCardController();
    controller2 = SlidingCardController();
  }

  String getState(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
      default:
        return 'Disconnected';
    }
  }

  void notifyBuzzer(BuzzerState state) async {
    MQTTManager manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/buzzer',
        identifier: _random.nextInt(20).toString(),
        state: state);
    print('fuck' + state.getAppConnectionState.toString());
    manager.initializeMQTTClient();
    await manager.connect();
    Message buzz = Message(id: '1', name: 'buzzer', data: '13', unit: '');
    String message = jsonEncode(buzz);
    manager.publish(message);
  }

  @override
  Widget build(BuildContext context) {
    final LightState lightState = Provider.of<LightState>(context);
    final BuzzerState buzzerState = Provider.of<BuzzerState>(context);
    final TempState tempState = Provider.of<TempState>(context);
    lightController = LightController(lightState);
    buzzerController = BuzzerController(buzzerState);
    tempController = TempController(tempState);

    if (lightState.getOverThreshold) {
      Future.delayed(Duration.zero, () async {
        notifyBuzzer(buzzerState);
      });
      lightState.setBoolThreshold(false);
    }

    if (tempState.getOverThreshold) {
      Future.delayed(Duration.zero, () async {
        notifyBuzzer(buzzerState);
      });
      tempState.setBoolThreshold(false);
    }

    DeviceSize().init(context);
    return Flexible(
      child: ListView(
        children: [
          SensorNotification(),
          buildTitle('Your Sensors'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SensorCard(
                      deviceName: 'Light',
                      imgUrl: 'assets/img/ceiling-light.svg',
                      imgPadding: 0,
                      connect: () {
                        // lightController.connectAdaServer();
                      },
                      disconnect: () {
                        // lightController.disconnectAdaServer();
                      },
                      controller: lightController,
                      state: lightState.getAppConnectionState,
                      value: lightState.getValueFromServer,
                    ),
                    SensorCard(
                      deviceName: 'Temperature',
                      imgUrl: 'assets/img/thermometer2.svg',
                      imgPadding: 6,
                      connect: () {
                        // lightController.connectAdaServer();
                      },
                      disconnect: () {
                        // lightController.disconnectAdaServer();
                      },
                      controller: tempController,
                      state: tempState.getAppConnectionState,
                      value: tempState.getValueFromServer,
                    ),
                  ],
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: [
                    // SensorCard(
                    //   deviceName: 'Sound',
                    //   imgUrl: 'assets/img/stereo.svg',
                    //   imgPadding: 8,
                    //   connect: () {
                    //     // lightController.connectAdaServer();
                    //   },
                    //   disconnect: () {
                    //     // lightController.disconnectAdaServer();
                    //   },
                    //   lightController: lightController,
                    //   state: lightState.getAppConnectionState,
                    // ),
                  ],
                )
              ],
            ),
          ),
          buildTitle('Your Notification Devices'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomCard(
              onTapped: () {
                print('on tap');
                if (controller.isCardSeparated == true) {
                  controller.collapseCard();
                } else {
                  controller.expandCard();
                }
              },
              slidingCardController: controller,
              device: 'Buzzer',
              state: getState(buzzerState.getAppConnectionState),
              connect: () {
                print('buzzer connect');
                buzzerController.connectAdaServer();
              },
              disconnect: () {
                print('buzzer disconnect');
                buzzerController.disconnectAdaServer();
              },
              message: buzzerState.getHistoryText,
              imgPath: 'assets/img/alarm.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomCard(
              onTapped: () {
                print('on tap');
                if (controller2.isCardSeparated == true) {
                  controller2.collapseCard();
                } else {
                  controller2.expandCard();
                }
              },
              slidingCardController: controller2,
              device: 'LCD',
              state: getState(MQTTAppConnectionState.disconnected),
              connect: () {
                print('buzzer connect');
              },
              disconnect: () {
                print('buzzer disconnect');
              },
              message: 'buzzerState.getHistoryText',
              imgPath: 'assets/img/lcd.png',
            ),
          ),
        ],
      ),
    );
  }

  Padding buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
