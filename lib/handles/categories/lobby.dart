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
      var playersInLobby = players.where((p) => p.category == Categories.lobby).map((element) => element.toMap()).toList();
      printD('list of players in lobby:\n$playersInLobby');
      answer['data'] = {'players_in_lobby': playersInLobby};
      //sending to all players in lobby
      for (var pl in players.where((p) => p.category == Categories.lobby)) {
        pl.socket.add(jsonEncode(answer));
      }
      break;
    case 'leave_lobby':
      player.category = Categories.station;
      answer['type'] = 'state';
      var playersInLobby = players.where((p) => p.category == Categories.lobby).map((element) => element.toMap()).toList();
      printD('list of players in lobby:\n$playersInLobby');
      answer['data'] = {'players_in_lobby': playersInLobby};
      //sending to all players in lobby
      for (var pl in players.where((p) => p.category == Categories.lobby)) {
        pl.socket.add(jsonEncode(answer));
      }
      break;
    default:
  }
}