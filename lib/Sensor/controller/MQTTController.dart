import 'package:study_space/Sensor/state/light_state.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import 'package:study_space/mqtt/MQTTManager.dart';
=======
import 'package:study_space/MQTTServer/MQTTManager.dart';
>>>>>>> main
import 'dart:math';

final _random = new Random();

class MQTTController {
  void connectAdaServer(MQTTLightState state, MQTTManager manager) {
    manager = MQTTManager(
        host: 'io.adafruit.com',
        topic: 'khanhdk0000/feeds/bbc-led',
        identifier: _random.nextInt(10).toString(),
        state: state);
    manager.initializeMQTTClient();
    manager.connect();
  }

  void disconnectAdaServer(MQTTManager manager) {
    manager.disconnect();
  }
}
