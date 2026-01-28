import 'package:eturnserver/globals.dart';

bool authentication(String email, password) {
  return registeredUsers.containsKey(email) && registeredUsers[email] == password;
}