import 'dart:convert';

import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';
import 'package:eturnserver/models/player.dart';

void handleTournamentRoom(Map<String, dynamic> json, Player player) {
  Map<String, dynamic> answer = {
    'category': 'tournament',
  };
  final String type = json['type'];
  printD('type: $type');
  switch (type) {
    case 'entered_to_tournament_room':
      answer['type'] = 'state';
      player.category = Categories.tournamentroom;
      player.activeShipId = json['ship_id'];
      var playersInTournamentRoom = players.where((p) => p.category == Categories.tournamentroom).map((element) => element.toMap()).toList();
      printD('list of players in TournamentRoom:\n$playersInTournamentRoom');
      answer['data'] = {'players_in_tournament_room': playersInTournamentRoom};
      //sending to all players in TournamentRoom
      for (var pl in players.where((p) => p.category == Categories.tournamentroom)) {
        pl.socket.add(jsonEncode(answer));
      }
    break;
    case 'change_ready':
      player.ready = !player.ready;
      answer['type'] = 'change_ready';
      var playersInTournamentRoom = players.where((p) => p.category == Categories.tournamentroom).map((element) => element.toMap()).toList();
      answer['data'] = {'change_ready': player.ready, 'player_id': player.id};
      for (var pl in players.where((p) => p.category == Categories.tournamentroom)) {
        pl.socket.add(jsonEncode(answer));
      }
      break;
  }
}