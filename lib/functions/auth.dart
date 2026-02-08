import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';

Map<String, dynamic> authentication(String email, password) {
  printD('auth for $email and $password from \n$registeredUsers');
  Map<String, dynamic> player = registeredUsers.firstWhere((element) => element['email'] == email && element['password'] == password, orElse: () => {});
  return player;
}