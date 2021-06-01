class User {
  final int _id;
  final String _username;
  final String _fname;
  final String _lname;
  final String _dob;


  User(this._id,this._username,this._fname,this._lname,this._dob) ;
  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['id'],json['username'],json['fname'],json['lname'],json['dob']);
  }
  String getUsername()
  {
    return this._username;
  }
  String getName()
  {
    return this._fname + ' ' + this._lname;
  }
  int getId() {
    return this._id;
  }
}