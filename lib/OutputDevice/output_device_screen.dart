import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/MQTTServer/state/MQTTAppState.dart';
import 'package:study_space/OutputDevice/controller/buzzer_controller.dart';
import 'package:study_space/OutputDevice/custom_card.dart';
import 'package:study_space/OutputDevice/state/buzzer_state.dart';
import 'package:study_space/constants.dart';
import 'devicesize.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class OutputDeviceScreen extends StatelessWidget {
  const OutputDeviceScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kContentColorDarkTheme),
        title: Text(
          'Output Device',
          style: TextStyle(
            color: kContentColorDarkTheme,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  SlidingCardController controller;
  SlidingCardController controller2;
  BuzzerController buzzerController;

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
    final MQTTBuzzerState buzzerState = Provider.of<MQTTBuzzerState>(context);
    buzzerController = BuzzerController(buzzerState);

    DeviceSize().init(context);
    return Container(
      child: Center(
        child: ListView(
          padding:
              EdgeInsets.symmetric(horizontal: 15, vertical: kDefaultPadding),
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              onTapped: () {
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
            SizedBox(
              height: kDefaultPadding,
            ),
            CustomCard(
              onTapped: () {
                if (controller2.isCardSeparated == true) {
                  controller2.collapseCard();
                } else {
                  controller2.expandCard();
                }
              },
              slidingCardController: controller2,
              device: 'LCD',
              state: 'Connected',
              connect: () {
                print('LCD connect');
              },
              disconnect: () {
                print('LCD disconnect');
              },
              message: '12345',
              imgPath: 'assets/img/lcd.png',
            ),
          ],
        ),
      ),
    );
  }
}
