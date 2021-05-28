class Schedule {
  int id;
  int rep;
  int period;
  List<Session> sessions = [];
}

class Session {
  String title;
  int start_time;
  int end_time;
}