import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/InputOutputDevice/view/input_output_screen.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Schedule/view/schedule_screen.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Notification/notification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Summary/view/all_sessions.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User user = FirebaseAuth.instance.currentUser;

class SideMenu extends StatelessWidget {
  // SideMenu({this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user == null ? 'example' : user.displayName,
              style: TextStyle(color: kContentColorDarkTheme),
            ),
            accountEmail: Text(
              user == null ? 'abc@email' : user.email,
              style: TextStyle(color: kContentColorDarkTheme),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/img/portrait.png'),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/img/mountains.png'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.cast_for_education),
          //   title:
          //       Text('Session', style: TextStyle(fontWeight: FontWeight.bold)),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SessionsView()),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.stacked_bar_chart),
            title:
                Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SummaryAllSessionsView()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today_sharp),
            title:
                Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScheduleScreen()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.construction),
            title:
                Text('Setting', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.devices_other_rounded),
            title:
                Text('Device', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InputOutputScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title:
                Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () async {
              final User user = _auth.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No one has signed in.'),
                  ),
                );
                return;
              }
              await _auth.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(user.displayName + ' has successfully signed out.'),
                ),
              );
              Navigator.of(context).pushNamedAndRemoveUntil(
                  kWelcomeScreen, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
