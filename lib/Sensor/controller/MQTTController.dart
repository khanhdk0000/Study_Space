import 'package:study_space/Sensor/state/light_state.dart';
import 'package:study_space/MQTTServer/MQTTManager.dart';
import 'dart:math';

import 'package:study_space/constants.dart';

final _random = new Random();

class MQTTController {
  void connectAdaServer(MQTTLightState state, MQTTManager manager) {
    manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/bbc-led',
        identifier: _random.nextInt(10).toString(),
        adaAPIKey: adaPassword,
        adaUserName: adaUserName,
        state: state);
    manager.initializeMQTTClient();
    manager.connect();
  }

  void disconnectAdaServer(MQTTManager manager) {
    manager.disconnect();
  }
}
