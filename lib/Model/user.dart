class User {
  final int id;
  final String fname;
  final String lname;
  final String email;

  User(this.id,this.email,this.fname,this.lname);
  String getEmail()
  {
    return this.email;
  }
  String getName()
  {
    return this.fname + ' ' + this.lname;
  }
}