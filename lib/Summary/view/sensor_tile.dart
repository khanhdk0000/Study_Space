import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:study_space/Model/sensor.dart';
import 'package:study_space/Controller/sensorController.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Summary/view/chart.dart';

class SensorTile extends StatefulWidget {
  final future;
  final String type;
  final String unit;
  final String imageAsset;
  const SensorTile({Key key, this.future, this.type, this.unit, this.imageAsset}) : super(key: key);

  @override
  _SensorTileState createState() => _SensorTileState();
}

class _SensorTileState extends State<SensorTile> {
  String text;
  double value;
  bool visible = false;
  SensorController s = SensorController();

  ///Set random seed
  int seed = math.Random().nextInt(100);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          value = s.getAverage(snapshot.data);
          text = value.toString() + ' ' + widget.unit;
          return _displaySensorTile(
              widget.type, text, value, snapshot.data, widget.imageAsset);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Text('Loading...');
      },
    );
  }

  Widget _displaySensorTile(String type, String text,
      double value, List<Sensor> sensorList, String imageAsset) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        focusColor: Colors.grey,
        onTap: () {
          if (sensorList.length != 0) {
            setState(() {
              visible = !visible;
              print(visible);
            });
          }
        },
        child: Container(
          width: double.infinity,
          // height: visible ? 400.0 : 90.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 23,
                spreadRadius: -13,
                color: kShadowColor.withOpacity(0.24),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image(
                      image: AssetImage(imageAsset),
                      height: 65.0,
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                              sensorList.length == 0
                                  ? 'No record'
                                  : 'Average: $text',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black54,
                              ))
                        ],
                      ),
                    ),
                    Transform.rotate(
                        angle: visible ? -math.pi / 2 : math.pi / 2,
                        child: Icon(Icons.chevron_right)),
                  ],
                ),
                Visibility(
                  visible: visible,
                  child: Container(
                    height: 250.0,
                    child: ChartView(sensorList: sensorList, type: type),
                  ),
                ),
                Visibility(
                    visible: visible,
                    child: SizedBox(height: kDefaultPadding * 0.5)),
                Visibility(
                  visible: visible,
                  child: _reviewView(value, type),
                ),
                Visibility(
                    visible: visible,
                    child: SizedBox(height: kDefaultPadding * 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewView(double value, String type) {
    SensorController s = SensorController();
    SensorEvaluation eval = s.getEvaluation(value, type);
    String reviewText = s.getReviewText(eval, type);
    String imageAsset = s.getImage(eval);
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          Image(
            image: AssetImage(imageAsset),
            height: 50.0,
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reviewText,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  SensorController().getRandomComment(type, seed),
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}