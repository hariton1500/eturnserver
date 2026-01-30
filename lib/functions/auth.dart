import 'package:eturnserver/globals.dart';

bool authentication(String email, password) {
  return registeredUsers.firstWhere((element) => element['email'] == email && element['password'] == password,).isNotEmpty;
}