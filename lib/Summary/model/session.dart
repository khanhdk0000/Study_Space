import 'package:intl/intl.dart';

class Session {
  String _id;
  String _sched_id;
  String _date;
  String _start_time;
  String _end_time;
  String _status;
  String _title;

  Session({String id, String sched_id, String date, String start_time,
          String end_time, String status, String title}) {
    this._id = id;
    this._sched_id = sched_id;
    this._date = date;
    this._start_time = start_time;
    this._end_time = end_time;
    this._status = status;
    this._title = title;
  }

  ///Getters
  String getId(){
    return this._id;
  }

  String getSchedId(){
    return this._sched_id;
  }

  String getDate(){
    return this._date;
  }

  String getStartTime(){
    return this._start_time;
  }

  String getEndTime(){
    return this._end_time;
  }

  String getScore(){
    //finished sessions but don't have score
    if (double.parse(this._status) == -1.0) {
      //TODO: update the score
      return "-1";
    } else {
      return (double.parse(this._status) * 100).toInt().toString();
    }
  }

  String getTitle(){
    return this._title;
  }

  String getFullTime(){
    return "${this.getStartTime().substring(0, 5)} - ${this.getEndTime().substring(0, 5)}";
  }

  String getDisplayDate(){
    DateTime date = DateFormat('MM/dd/yyyy').parse(this.getDate());
    return DateFormat('EEEE, MMM d').format(date);
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return Session(
      id: json['id'].toString(),
      sched_id: json['sched_id'].toString(),
      date: json['date'].toString(),
      start_time: json['start_time'].toString(),
      end_time: json['end_time'].toString(),
      status: json['status'].toString(),
      title: json['title'].toString(),
    );
  }

  List<String> displaySession(){
    print('Displaying session');
    return [this.getId(), this.getFullTime(), this.getTitle(), this.getDisplayDate(), this.getScore()];
  }

}