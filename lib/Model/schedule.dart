class Schedule {
  final int _id;
  final int _rep;
  final int _per;
  final String startDate;
  final String startTime;
  final String endTime;
  final int _userId;

  Schedule(this._id, this._rep, this._per, this.startDate, this.startTime,
      this.endTime, this._userId);

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        json['id'],
        json['repetition'],
        json['period'],
        json['start_date'],
        json['start_time'],
        json['end_time'],
        json['_user_id']);
  }

  int getUserId() => this._userId;
}
