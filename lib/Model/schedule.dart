class Schedule {
  final int _id;
  final int _rep;
  final int _per;
  final String start_date;
  final String start_time;
  final String end_time;
  final int _user_id;

  Schedule(this._id, this._rep, this._per, this.start_date, this.start_time, this.end_time, this._user_id);

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(int.parse(json['id']), int.parse(json['repetition']), int.parse(json['period']), json['start_date'], json['start_time'], json['end_time'], int.parse(json['user_id']));
  }

  String upcomingDate(){
    final dateValues = start_date.split("/");
    var date = DateTime.parse("${dateValues[2]}-${dateValues[0]}-${dateValues[1]} " + end_time);
    var repeat = 0;

    while (date.isBefore(DateTime.now()) && repeat <= _rep){
      date = date.add(Duration(days: _per));
      repeat += 1;
    }

    if (date.isBefore(DateTime.now())) {
      return "Completed";
    }

    final year = date.year.toString();
    final month = date.month.toString();
    final day = date.day.toString();

    return "$month/$day/$year";
  }


  int getUserId() => this._user_id;
}