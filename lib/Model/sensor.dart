class Sensor {
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
  }
}