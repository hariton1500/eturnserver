//handle station messages
import 'dart:convert';

import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/models/player.dart';

void handleStation(Map<String, dynamic> json, Player player) {
  Map<String, dynamic> answer = {
    'category': 'station',
  };
  final String type = json['type'];
  printD('type: $type');
  switch (type) {
    case 'get_state':
      answer['type'] = 'state';
      answer['data'] = {'player_id': player.id};
      player.socket.add(jsonEncode(answer));
      break;
    default:
  }
}