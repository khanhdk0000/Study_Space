import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Controller/userController.dart';

User user;
int user_id; //current user id
bool isLoggedIn;
String characterNames = userController().getCharacterName();