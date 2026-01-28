import 'dart:convert';
import 'dart:io';

import 'package:eturnserver/battle.dart';
import 'package:eturnserver/functions/dbloading.dart';
import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';
import 'package:eturnserver/models/lobby.dart';
import 'package:eturnserver/models/player.dart';

Future<int> startServer() async {
  
  //loading data from db
  bool res = await loadingFromDB();
  if (res) sb!.dispose();

  printD('Start HttpServer...');
  final server = await HttpServer.bind('0.0.0.0', 8080);

  printD('Listening for data.......');
  await for (HttpRequest req in server) {
    if (WebSocketTransformer.isUpgradeRequest(req)) {
      final socket = await WebSocketTransformer.upgrade(req);

      final lobby = Lobby('lobby-1');
      socket.listen((data) {
        try {
          
          final json = jsonDecode(data);
          print(data);

          switch (json['type']) {
            case 'join_lobby':
              lobby.addPlayer(
                Player(
                  id: json['playerId'],
                  socket: socket,
                ),
              );
              break;

            case 'select_team':
              lobby.setTeam(json['playerId'], json['teamId']);
              break;

            case 'ready':
              lobby.setReady(json['playerId'], json['value']);
              break;

            case 'auto_teams':
              autoAssignTeams(lobby);
              break;

            case 'start_battle':
              if (lobby.allReady) {
                final battle = startBattleFromLobby(lobby);
                startBattleLoop(battle);
              }
              break;
          }

          broadcastLobbyState(lobby);
          /*
          if (json['type'] == 'command') {
            battle.addCommand(
              Command(
                shipId: json['shipId'],
                type: CommandType.values.byName(json['command']),
                targetId: json['targetId'],
              ),
            );
          }

          if (json['type'] == 'pause') {
            battle.paused = json['value'];
          }*/
          print(json);
        } catch (e) {
          print(e);
        }
      });
    }
  }









  return 0;
}