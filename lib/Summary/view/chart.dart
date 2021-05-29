import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChartView extends StatefulWidget {
  const ChartView({Key key}) : super(key: key);

  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  List<charts.Series<SensorData, int>> _seriesLineData;
  _generateData() {
    var line_sensor_data = [
      new SensorData(0, 200),
      new SensorData(5, 205),
      new SensorData(10, 202),
      new SensorData(15, 187),
      new SensorData(20, 189),
      new SensorData(25, 193),
      new SensorData(35, 200),
      new SensorData(50, 201),
      new SensorData(70, 203),
      new SensorData(75, 209),
    ];
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
        id: 'Lux',
        data: line_sensor_data,
        domainFn: (SensorData sensors, _) => sensors.min,
        measureFn: (SensorData sensors, _) => sensors.val,
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    _seriesLineData = [];
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: charts.LineChart(
        _seriesLineData,
        defaultRenderer: new charts.LineRendererConfig(
          includePoints: true,
          includeArea: true,
        ),
        animate: true,
        animationDuration: Duration(seconds: 1),
        behaviors: [
          // new charts.ChartTitle(
          //   'Time (minutes)',
          //   titleStyleSpec: TextStyleSpec(
          //     fontSize: 14,
          //   ),
          //   behaviorPosition: charts.BehaviorPosition.bottom,
          //   titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
          // ),
          // new charts.ChartTitle(
          //   'Value (Lux)',
          //   titleStyleSpec: TextStyleSpec(
          //     fontSize: 14,
          //   ),
          //   behaviorPosition: charts.BehaviorPosition.start,
          //   titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
          // ),
        ],
      ),
    );
  }
}

class SensorData {
  int min;
  int val;

  SensorData(this.min, this.val);
}
