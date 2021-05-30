import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:study_space/Sensor/state/light_state.dart';
import 'package:provider/provider.dart';
import 'package:study_space/constants.dart';

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
