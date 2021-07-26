class Sensor {
  final String id;
  final String name;
  final String type;
  final String timestamp;
  int count;
  double data;

  Sensor(this.id, this.name, this.type, this.data, this.timestamp, this.count);
  double getValue() => this.data;
  String getName() => this.name;
  String getType() => this.type;
  String getId() => this.id;
  String getTimestamp() => this.timestamp;

  factory Sensor.fromJson(Map<String, dynamic> json, int count) {
    print(json.toString());
    double data;
    if (json['type'] != 'TH') {
      data = double.parse(json['data']);
    } else {
      data = double.parse(json['data'].split('-')[0]);
    }
    return Sensor(json['id'], json['name'], json['type'], data, json['timestamp'], count);
  }
}