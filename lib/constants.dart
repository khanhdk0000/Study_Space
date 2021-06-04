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

String adaTopic = '$khanhuser/feeds/';
String adaUserName = khanhuser;
String adaPassword = khanhApi;

String adaTopicTemp = adaTopic + 'temp';
String adaTopicLight = adaTopic + 'light';
String adaTopicSound = adaTopic + 'sound';
String adaTopicBuzzer = adaTopic + 'buzzer';
String adaTopicLCD = adaTopic + 'iot_led';

String khanhuser = 'khanhdk0000';
String khanhApi = 'aio_mwIg04X7dgAqiO4gVjJ9QZG0LxXR';
String cseBBC = 'CSE_BBC';
String cseBBC1 = 'CSE_BBC1';
String bbcAPIKey = 'aio_aaXQ56Mtv3RWWwps1wWDPCWdq8S6';
String bbc1APIKey = 'aio_wXPC09rE51bD1CFHcZnaBmTzeFiW';

enum MQTTAppConnectionState { connected, disconnected, connecting }
enum SensorEvaluation { normal, warning, bad }
