import 'package:flutter/material.dart';
import 'package:study_space/constants.dart';

class SensorNotification extends StatelessWidget {
  const SensorNotification({
    Key key,
    @required this.state,
    @required this.device,
  }) : super(key: key);

  final state;
  final String device;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: state.getOverThreshold,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF3e9ee7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 170,
              child: Text(
                'Your $device condition is not appropriate, please beware!',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: Color(0xFFffcd15),
              ),
              onPressed: () {
                state.setBoolThreshold(false);
                print('Dismiss');
              },
              child: Text(
                'Dismiss',
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
