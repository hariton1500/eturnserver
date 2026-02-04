import 'dart:convert';

import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';
import 'package:eturnserver/models/player.dart';

void handleLobby(Map<String, dynamic> json, Player player) {
  Map<String, dynamic> answer = {
    'category': 'lobby',
  };
  final String type = json['type'];
  printD('type: $type');
  switch (type) {
    case 'entered_to_lobby':
      answer['type'] = 'state';
      player.category = Categories.lobby;
      player.activeShipId = json['ship_id'];
      answer['data'] = {'players_in_lobby': players.where((p) => p.category == Categories.lobby).map((element) => element.toMap())};
      //sending to all players in lobby
      for (var pl in players.where((p) => p.category == Categories.lobby)) {
        pl.socket.add(jsonEncode(answer));
      }
      break;
    default:
  }
}