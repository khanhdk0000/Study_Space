import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:study_space/Model/sensor.dart';

class ChartView extends StatefulWidget {
  final List<Sensor> sensorList;
  final String type;
  const ChartView({Key key, this.sensorList, this.type}) : super(key: key);

  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  List<charts.Series<Sensor, int>> _seriesLineData;
  _generateData() {
    List<Sensor> sensorChartList = List.from(widget.sensorList);
    if (sensorChartList.length == 1){
      Sensor s = sensorChartList[0];
      sensorChartList.add(Sensor(s.id, s.name, s.type, s.data, s.timestamp, s.count + 1));
    }
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(chartColor(widget.type)),
        id: 'Lux',
        data: sensorChartList,
        domainFn: (Sensor sensors, _) => sensors.count,
        measureFn: (Sensor sensors, _) => sensors.data.round(),
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
          includeArea: true,
        ),
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

  Color chartColor(String type){
    if (type == 'Light') {
      return Colors.deepOrange;
    } else if (type == 'Sound') {
      return Colors.blue;
    } else if (type == 'Temperature') {
      return Colors.yellow;
    }
  }
}

class SensorData {
  int min;
  int val;

  SensorData(this.min, this.val);
}
