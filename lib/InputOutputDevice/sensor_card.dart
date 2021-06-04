import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study_space/InputOutputDevice/controller/controller.dart';
import 'package:study_space/InputOutputDevice/view/light_sensor_screen.dart';
import 'package:study_space/InputOutputDevice/view/sound_sensor_screen.dart';
import 'package:study_space/InputOutputDevice/view/temp_sensor_screen.dart';
import 'package:study_space/constants.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({
    Key key,
    @required this.deviceName,
    @required this.imgUrl,
    this.imgPadding = 2,
    @required this.controller,
    @required this.state,
    @required this.value,
  }) : super(key: key);

  final String deviceName;
  final String imgUrl;
  final double imgPadding;
  final Controller controller;
  final double value;

  final MQTTAppConnectionState state;

  Color getConnectionColor(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return Colors.greenAccent;
      case MQTTAppConnectionState.connecting:
        return Colors.yellowAccent;
      case MQTTAppConnectionState.disconnected:
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = getConnectionColor(state);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            if (deviceName == "Light") {
              return LightSensorScreen(
                controller: controller,
              );
            } else if (deviceName == "Temperature") {
              return TempSensorScreen(
                controller: controller,
              );
            } else
              return SoundSensorScreen(
                controller: controller,
              );
          },
        ),
      ),
      child: Container(
        height: 150,
        width: (MediaQuery.of(context).size.width - (kDefaultPadding * 2)) / 2 -
            kDefaultPadding,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 20,
              color: Color(0xFF4056C6).withOpacity(.15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(imgPadding),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFedf9ff),
                  ),
                  child: SvgPicture.asset(
                    imgUrl,
                    color: Color(0xFF3e9ee7),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  // color: color,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Text('', textAlign: TextAlign.center),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                deviceName,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${value.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
