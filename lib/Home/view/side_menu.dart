import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/Sensor/view/sensors_screen.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/constants.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'example',
              style: TextStyle(color: kContentColorDarkTheme),
            ),
            accountEmail: Text(
              'abc@email',
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
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.cast_for_education),
            title: Text('Session'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.stacked_bar_chart),
            title: Text('Summary'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.calendar_today_sharp),
            title: Text('Schedule'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.timer_outlined),
            title: Text('Timer'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.device_thermostat),
            title: Text('Sensor'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SensorScreen(),
              ),
            ),
            trailing: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.redAccent),
              child: Center(
                child: Text(
                  '1',
                  style: TextStyle(color: kContentColorDarkTheme),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
