import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFFC727);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
const kShadowColor = Color(0xFF343a40);
const kDefaultPadding = 20.0;

const kHomeScreen = 'homeScreen';
const kWelcomeScreen = 'welcomeScreen';

const webhost = "studyspace-mdp-2021.000webhostapp.com";
const webkey = "http://dadn.esp32thanhdanh.link";

String adaTopic = '$cseBBC/feeds/';
String adaUserName = cseBBC;
String adaPassword = bbcAPIKey;

String adaTopic1 = '$cseBBC1/feeds/';
String adaUserName1 = cseBBC1;
String adaPassword1 = bbc1APIKey;

String adaTopicTemp = adaTopic + 'bk-iot-temp-humid';
String adaTopicLight = adaTopic1 + 'bk-iot-light';
String adaTopicSound = adaTopic1 + 'bk-iot-sound';
String adaTopicBuzzer = adaTopic + 'bk-iot-speaker';
String adaTopicLCD = adaTopic + 'bk-iot-lcd';
String adaTopicInfrared = adaTopic1 + 'bk-iot-infrared';

String khanhuser = 'khanhdk0000';
String khanhApi = 'aio_SEJW997mEyVAkKmrJS8is1m5n6VH';
String cseBBC = 'CSE_BBC';
String cseBBC1 = 'CSE_BBC1';

String bbcAPIKey = 'aio_qyBr29pmfJC09tUFB5n9Ap9AtIwD';
String bbc1APIKey = 'aio_ieyO306EGPxQmn7S23iE7p3jIG8O';

String host = '10.0.2.2:5000';

enum MQTTAppConnectionState { connected, disconnected, connecting }
enum SensorEvaluation { normal, warning, bad }

String sensorDescription = """
We have three sensors to assist your learning:

- Light: Capture the lighting condition in your room, if it is too dark(<100) or too bright(>500), you will be notified.

- Sound: Measure the sound threshold in your room, value beyond 500 is bad for your ears.

- Temperature: The temperature in your room should not be over 30.""";
