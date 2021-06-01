class Sensor {
<<<<<<< HEAD
  final int id;
  final String name;
  final String type;
  double data;

  Sensor(this.id,this.name,this.type);
  double getValue()
  {
    return this.data;
  }
  String getType()
  {
    return this.type;
  }
  String getName()
  {
    return this.name;
=======
  final String id;
  final String name;
  final String type;
  final String timestamp;
  double data;

  Sensor(this.id, this.name, this.type, this.data, this.timestamp);
  double getValue() => this.data;
  String getName() => this.name;
  String getType() => this.type;
  String getId() => this.id;
  String getTimestamp() => this.timestamp;

  factory Sensor.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    double data;
    if (json['type'] != 'TH') {
      data = double.parse(json['data']);
    } else {
      data = double.parse(json['data'].split('-')[0]);
    }
    return Sensor(json['id'], json['name'], json['type'], data, json['timestamp']);
>>>>>>> main
  }
}