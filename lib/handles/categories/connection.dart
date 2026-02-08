import 'dart:convert';
import 'dart:io';

import 'package:eturnserver/functions/auth.dart';
import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';
import 'package:eturnserver/models/player.dart';

void handleConnect(Map<String, dynamic> json, WebSocket s) {
  Map<String, dynamic> answer = {
    'category': 'connection',
  };
  final String type = json['type'];
  printD('type: $type');
  switch (type) {
    case 'login':
      answer['type'] = 'login';
      printD('authenticating...');
      final String email = json['email'];
      final result = authentication(email, json['password']);
      if (result.isNotEmpty) {
        printD('success.');
        Player player = Player(id: result['id'], socket: s);
        player.email = email;
        if (!players.any((p) => p.email == email)) players.add(player);
        printD('added player $player to active');
        printD('List of active players:\n$players');
        answer['player'] = {'id': player.id};
      } else {
        printD('failed');
      }
      //sending answer
      answer['result'] = result.isNotEmpty;
      printD('sending:\n$answer');
      s.add(jsonEncode(answer));
      break;
    case 'logout':
      final String email = json['email'];
      printD('player $email logged out');
      //players.removeWhere((p) => p.id == email);
      break;
    default:
  }
}