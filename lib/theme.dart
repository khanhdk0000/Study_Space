import 'package:flutter/cupertino.dart';
import 'package:study_space/constants.dart';
import 'package:flutter/material.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kContentColorLightTheme),
    fontFamily: 'ProximaNova',
    // textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
    //     .apply(bodyColor: kContentColorLightTheme),
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      // secondary: kSecondaryColor,
      error: kErrorColor,
    ),
  );
  // return ThemeData.light().copyWith(
  //   primaryColor: kPrimaryColor,
  //   scaffoldBackgroundColor: Colors.white,
  //   appBarTheme: appBarTheme,
  //   iconTheme: IconThemeData(color: kContentColorLightTheme),
  //   textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
  //       .apply(bodyColor: kContentColorLightTheme),
  //   colorScheme: ColorScheme.light(
  //     primary: kPrimaryColor,
  //     // secondary: kSecondaryColor,
  //     error: kErrorColor,
  //   ),
  // );
}

final appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
