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
return Schedule(json['id'], json['repetition'], json['period'], json['start_date'], json['start_time'], json['end_time'], json['_user_id']);
}

int getUserId() => this._user_id;

}