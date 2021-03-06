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

  String getScore() {
    return int.parse(this._status).toString();
  }

  void setScore(String score) {
    this._status = score;
  }

  void setUntitled(){
    if (this._title == '') {
      this._title = 'Untitled';
    }
  }

  String getTitle(){
    return this._title;
  }

  String getFullTime(){
    return "${this.getStartTime().substring(0, 5)} - ${this.getEndTime().substring(0, 5)}";
  }

  int getDuration(){
    // Session duration in minutes
      final startTime = DateFormat('hh:mm:ss').parse(this._start_time);
      final endTime = DateFormat('hh:mm:ss').parse(this._end_time);
      final difference = endTime.difference(startTime);
      return difference.inMinutes;
  }

  String getDisplayDate(){
    DateTime date = DateFormat('MM/dd/yyyy').parse(this.getDate());
    return DateFormat('EEEE, MMM d').format(date);
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    Session session = Session(
      id: json['id'].toString(),
      sched_id: json['sched_id'].toString(),
      date: json['date'].toString(),
      start_time: json['start_time'].toString(),
      end_time: json['end_time'].toString(),
      status: json['status'].toString(),
      title: json['title'].toString(),
    );
    session.setUntitled();
    return session;
  }

  List<String> displaySession() {
    return [this.getFullTime(), this.getTitle(), this.getDisplayDate(), this.getScore(), this.getId()];
  }

}