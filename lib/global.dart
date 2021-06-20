import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_space/Controller/userController.dart';

User user;
int user_id; //current user id
bool isLoggedIn;
String characterNames = userController().getCharacterName();

void checkId(BuildContext context) {
  if(user_id == 0 || user_id == null) {
    userController().popup(context);
    // userController().reroute(context);
  }
}