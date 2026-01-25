import 'dart:convert';
import 'dart:io';

import 'package:eturnserver/battle.dart';
import 'package:eturnserver/models/lobby.dart';
import 'package:eturnserver/models/player.dart';

Future<int> startServer() async {

  final server = await HttpServer.bind('0.0.0.0', 8080);
  //final battle = BattleSession('battle-1');

  //battle.addShip(Ship(id: 'ship1', teamId: 'A'));
  //battle.addShip(Ship(id: 'ship2', teamId: 'B'));

  //startBattleLoop(battle);

  await for (HttpRequest req in server) {
    if (WebSocketTransformer.isUpgradeRequest(req)) {
      final socket = await WebSocketTransformer.upgrade(req);

      final lobby = Lobby('lobby-1');
      socket.listen((data) {
        final json = jsonDecode(data);

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
      });
    }
  }









  return 0;
}