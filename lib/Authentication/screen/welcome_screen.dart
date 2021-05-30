import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study_space/Authentication/screen/log_in_screen.dart';
import 'package:study_space/Authentication/components/round_button.dart';
import 'package:study_space/constants.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Body()),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            SvgPicture.asset(
              'assets/img/welcome.svg',
              height: size.height * 0.4,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Text(
              'Welcome to Study Space',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedButton(
              size: size,
              text: 'LOGIN',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogInScreen()),
                );
              },
            ),
            RoundedButton(
              size: size,
              text: 'SIGNUP',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              color: kPrimaryColor.withOpacity(0.35),
              textColor: kContentColorLightTheme,
            ),
          ],
        ),
      ),
    );
  }
}
