import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_space/Controller/userController.dart';

User user;
int userId; //current user id
bool isLoggedIn;
String characterNames = userController().getCharacterName();

void checkId(BuildContext context) {
  if (userId == 0 || userId == null) {
    userController().popup(context);
    // userController().reroute(context);
  }
}
