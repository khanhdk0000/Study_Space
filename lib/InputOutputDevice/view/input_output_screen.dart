import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/InputOutputDevice/sensor_card.dart';
import 'package:study_space/InputOutputDevice/sensor_notification.dart';
import 'package:study_space/InputOutputDevice/state/lcd_state.dart';
import 'package:study_space/InputOutputDevice/state/sound_state.dart';
import 'package:study_space/InputOutputDevice/state/temp_state.dart';
import 'package:study_space/InputOutputDevice/view/sensor_screen_header.dart';
import 'package:study_space/InputOutputDevice/state/buzzer_state.dart';
import 'package:study_space/InputOutputDevice/state/light_state.dart';
import 'package:study_space/InputOutputDevice/custom_card.dart';
import 'package:study_space/devicesize.dart';
import 'package:study_space/constants.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:circular_menu/circular_menu.dart';

class InputOutputScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(child: Body()),
    );
  }
}

class Body extends StatelessWidget {
  // const Body({required Key key}) : super(key: key);

  Widget _topView(BuildContext context) {
    ///The top view include the drawer button and screen name.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MenuButton(),
          Row(
            children: [
              Text(
                "Your Devices",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 23.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  'assets/img/internet-of-things2.svg',
                  // color: Color(0xFF3e9ee7),
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          InkWell(
            onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text('What are these sensors all about?'),
                      content: Column(
                        children: [
                          Image(
                              image: AssetImage(
                                  'assets/img/internet-of-things.png')),
                          Text(sensorDescription),
                        ],
                      ),
                      scrollable: true,
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text('OK'),
                        ),
                      ],
                    )),
            child: Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _topView(context),
        CustomScrollSensorList(),
      ],
    );
  }
}

class CustomScrollSensorList extends StatefulWidget {
  @override
  _CustomScrollSensorListState createState() => _CustomScrollSensorListState();
}

class _CustomScrollSensorListState extends State<CustomScrollSensorList> {
  SlidingCardController controller;
  SlidingCardController controller2;

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

  @override
  Widget build(BuildContext context) {
    LightState lightState = Provider.of<LightState>(context);
    SoundState soundState = Provider.of<SoundState>(context);
    TempState tempState = Provider.of<TempState>(context);
    BuzzerState buzzerState = Provider.of<BuzzerState>(context);
    LCDState lcdState = Provider.of<LCDState>(context);

    DeviceSize().init(context);
    return Flexible(
      child: Stack(
        children: [
          ListView(
            children: [
              SensorNotification(
                state: lightState,
                device: "light",
              ),
              SensorNotification(state: tempState, device: "temperature"),
              SensorNotification(state: soundState, device: "sound"),
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
                          state: lightState.getAppConnectionState,
                          value:
                              lightState.getValueFromServer.toStringAsFixed(0),
                        ),
                        SensorCard(
                          deviceName: 'Temperature',
                          imgUrl: 'assets/img/thermometer2.svg',
                          imgPadding: 6,
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
                          state: soundState.getAppConnectionState,
                          value:
                              soundState.getValueFromServer.toStringAsFixed(0),
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
                  slidingCardController: controller,
                  device: 'Buzzer',
                  state: getState(buzzerState.getAppConnectionState),
                  connect: () {
                    print('buzzer connect');
                    buzzerState.setAppConnectionState(
                        MQTTAppConnectionState.connected);
                  },
                  disconnect: () {
                    print('buzzer disconnect');
                    buzzerState.setAppConnectionState(
                        MQTTAppConnectionState.disconnected);
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
                  slidingCardController: controller2,
                  device: 'LCD',
                  state: getState(lcdState.getAppConnectionState),
                  connect: () {
                    print('LCD connect');
                    lcdState.setAppConnectionState(
                        MQTTAppConnectionState.connected);
                  },
                  disconnect: () {
                    print('LCD disconnect');
                    lcdState.setAppConnectionState(
                        MQTTAppConnectionState.disconnected);
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
            toggleButtonAnimatedIconData: AnimatedIcons.menu_close,
            startingAngleInRadian: pi + 0.1,
            endingAngleInRadian: pi + 1.2,
            toggleButtonColor: Colors.deepPurpleAccent,
            alignment: Alignment.bottomRight,
            items: [
              CircularMenuItem(
                iconSize: 40,
                onTap: () {
                  print('tapped');

                  lightState.setAppConnectionState(
                      MQTTAppConnectionState.disconnected);
                  tempState.setAppConnectionState(
                      MQTTAppConnectionState.disconnected);
                  soundState.setAppConnectionState(
                      MQTTAppConnectionState.disconnected);
                  buzzerState.setAppConnectionState(
                      MQTTAppConnectionState.disconnected);
                  lcdState.setAppConnectionState(
                      MQTTAppConnectionState.disconnected);
                },
                icon: Icons.refresh,
                color: Colors.teal,
              ),
              CircularMenuItem(
                iconSize: 40,
                onTap: () {
                  print('tapped');
                  lightState
                      .setAppConnectionState(MQTTAppConnectionState.connected);
                  tempState
                      .setAppConnectionState(MQTTAppConnectionState.connected);
                  soundState
                      .setAppConnectionState(MQTTAppConnectionState.connected);
                  buzzerState
                      .setAppConnectionState(MQTTAppConnectionState.connected);
                  lcdState
                      .setAppConnectionState(MQTTAppConnectionState.connected);
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
