import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/InputOutputDevice/controller/buzzer_controller.dart';
import 'package:study_space/InputOutputDevice/controller/lcd_controller.dart';
import 'package:study_space/InputOutputDevice/controller/light_controller.dart';
import 'package:study_space/InputOutputDevice/controller/sound_controller.dart';
import 'package:study_space/InputOutputDevice/controller/temp_controller.dart';
import 'package:study_space/InputOutputDevice/sensor_card.dart';
import 'package:study_space/InputOutputDevice/sensor_notification.dart';
import 'package:study_space/InputOutputDevice/state/lcd_state.dart';
import 'package:study_space/InputOutputDevice/state/sound_state.dart';
import 'package:study_space/InputOutputDevice/state/temp_state.dart';
import 'package:study_space/InputOutputDevice/view/sensor_screen_header.dart';
import 'package:study_space/InputOutputDevice/state/buzzer_state.dart';
import 'package:study_space/InputOutputDevice/state/light_state.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'package:study_space/InputOutputDevice/custom_card.dart';
import 'package:study_space/OutputDevice/devicesize.dart';
import 'package:study_space/constants.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:convert';
import 'package:circular_menu/circular_menu.dart';

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
  LCDController lcdController;
  TempController tempController;
  SoundController soundController;
  LightState lightState;
  BuzzerState buzzerState;
  TempState tempState;
  SoundState soundState;
  LCDState lcdState;

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

  void notifyDevice(var state, String device, String data) async {
    MQTTManager manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: device == 'LCD' ? adaTopicLCD : adaTopicBuzzer,
        identifier: _random.nextInt(20).toString(),
        adaAPIKey: adaPassword,
        adaUserName: adaUserName,
        state: state);
    manager.initializeMQTTClient();
    await manager.connect();
    Message buzz = Message(id: '1', name: '$device', data: '$data', unit: '');

    String message = jsonEncode(buzz);
    manager.publish(message);
  }

  void initializeEverything() {
    if (lightState.getAppConnectionState ==
        MQTTAppConnectionState.disconnected) {
      lightController.connectAdaServer();
    }
    if (buzzerState.getAppConnectionState ==
        MQTTAppConnectionState.disconnected) {
      buzzerController.connectAdaServer();
    }
    if (tempState.getAppConnectionState ==
        MQTTAppConnectionState.disconnected) {
      tempController.connectAdaServer();
    }
    if (soundState.getAppConnectionState ==
        MQTTAppConnectionState.disconnected) {
      soundController.connectAdaServer();
    }
    if (lcdState.getAppConnectionState == MQTTAppConnectionState.disconnected) {
      lcdController.connectAdaServer();
    }
  }

  void disableEverything() {
    if (lightState.getAppConnectionState !=
        MQTTAppConnectionState.disconnected) {
      lightController.disconnectAdaServer();
    }
    if (buzzerState.getAppConnectionState !=
        MQTTAppConnectionState.disconnected) {
      buzzerController.disconnectAdaServer();
    }
    if (tempState.getAppConnectionState !=
        MQTTAppConnectionState.disconnected) {
      tempController.disconnectAdaServer();
    }
    if (soundState.getAppConnectionState !=
        MQTTAppConnectionState.disconnected) {
      soundController.disconnectAdaServer();
    }
    if (lcdState.getAppConnectionState != MQTTAppConnectionState.disconnected) {
      lcdController.disconnectAdaServer();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    lightState = Provider.of<LightState>(context);
    buzzerState = Provider.of<BuzzerState>(context);
    tempState = Provider.of<TempState>(context);
    soundState = Provider.of<SoundState>(context);
    lcdState = Provider.of<LCDState>(context);
    lightController = LightController(lightState);
    buzzerController = BuzzerController(buzzerState);
    tempController = TempController(tempState);
    soundController = SoundController(soundState);
    lcdController = LCDController(lcdState);

    if (lightState.getOverThreshold ||
        tempState.getOverThreshold ||
        soundState.getOverThreshold) {
      Future.delayed(Duration.zero, () async {
        notifyDevice(buzzerState, 'SPEAKER', '13');
      });
      if (lightState.getOverThreshold) {
        notifyDevice(lcdState, 'LCD', 'light overthershold');
        lightState.setBoolThreshold(false);
      }
      if (tempState.getOverThreshold) {
        notifyDevice(lcdState, 'LCD', 'Temperature overthershold');
        tempState.setBoolThreshold(false);
      }
      if (soundState.getOverThreshold) {
        soundState.setBoolThreshold(false);
        notifyDevice(lcdState, 'LCD', 'Sound overthershold');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DeviceSize().init(context);
    return Flexible(
      child: Stack(
        children: [
          ListView(
            children: [
              SensorNotification(),
              buildTitle('Your Sensors'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SensorCard(
                          deviceName: 'Light',
                          imgUrl: 'assets/img/ceiling-light.svg',
                          imgPadding: 0,
                          controller: lightController,
                          state: lightState.getAppConnectionState,
                          value: lightState.getValueFromServer,
                        ),
                        SensorCard(
                          deviceName: 'Temperature',
                          imgUrl: 'assets/img/thermometer2.svg',
                          imgPadding: 6,
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
                        SensorCard(
                          deviceName: 'Sound',
                          imgUrl: 'assets/img/stereo.svg',
                          imgPadding: 8,
                          controller: soundController,
                          state: soundState.getAppConnectionState,
                          value: soundState.getValueFromServer,
                        ),
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
                  controller: buzzerController,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CustomCard(
                  onTapped: () {
                    print('on tap');
                    if (controller2.isCardSeparated == true) {
                      controller2.collapseCard();
                    } else {
                      controller2.expandCard();
                    }
                  },
                  controller: lcdController,
                  slidingCardController: controller2,
                  device: 'LCD',
                  state: getState(lcdState.getAppConnectionState),
                  connect: () {
                    print('buzzer connect');
                    lcdController.connectAdaServer();
                  },
                  disconnect: () {
                    print('buzzer disconnect');
                    lcdController.disconnectAdaServer();
                  },
                  message: lcdState.getHistoryText,
                  imgPath: 'assets/img/lcd.png',
                ),
              ),
              SizedBox(
                height: kDefaultPadding * 3,
              ),
            ],
          ),
          CircularMenu(
            startingAngleInRadian: pi + 0.1,
            endingAngleInRadian: pi + 1.2,
            toggleButtonColor: Colors.deepPurpleAccent,
            alignment: Alignment.bottomRight,
            items: [
              CircularMenuItem(
                iconSize: 40,
                onTap: () {
                  print('tapped');
                  disableEverything();
                },
                icon: Icons.refresh,
                color: Colors.teal,
              ),
              CircularMenuItem(
                iconSize: 40,
                onTap: () {
                  print('tapped');
                  initializeEverything();
                },
                icon: Icons.sensors,
                color: Colors.amber,
              ),
            ],
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
