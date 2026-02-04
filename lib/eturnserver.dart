import 'dart:convert';
import 'dart:io';

import 'package:eturnserver/battle.dart';
import 'package:eturnserver/functions/dbloading.dart';
import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';
import 'package:eturnserver/handles/categories/connection.dart';
import 'package:eturnserver/handles/categories/lobby.dart';
import 'package:eturnserver/handles/categories/station.dart';
import 'package:eturnserver/handles/categories/tournamentroom.dart';
import 'package:eturnserver/models/lobby.dart';

Future<int> startServer() async {
  
  //loading data from db
  bool res = await loadingFromDB();
  if (res) sb!.dispose();

  printD('Start HttpServer...');
  final server = await HttpServer.bind('0.0.0.0', 8080);

  printD('Listening for requests.......');
  await for (HttpRequest req in server) {
    printD('incoming request from ${req.connectionInfo!.remoteAddress.address}:${req.connectionInfo!.remotePort}');
    printD('Checks whether the request is a valid WebSocket upgrade request?');
    if (WebSocketTransformer.isUpgradeRequest(req)) {
      final socket = await WebSocketTransformer.upgrade(req);
      printD('True. Socket: ${socket.toString()}');

      final lobby = Lobby('lobby-1');
      printD('Start listening for data from this socket...');
      socket.listen((data) {
        printD('recieved:\n${data.toString()}');
        try {
          
          final json = jsonDecode(data);
          final category = json['category'].toString();
          printD('handle category $category');
          switch (category) {
            case 'connection':
              handleConnect(json, socket);
              break;

            case 'station':
              var player = players.firstWhere((p) => p.socket == socket);
              handleStation(json, player);
              break;

            case 'lobby':
              var player = players.firstWhere((p) => p.socket == socket);
              handleLobby(json, player);
              break;

            case 'tournament_room':
              var player = players.firstWhere((p) => p.socket == socket);
              handleTournamentRoom(json, player);
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
          //print(json);
        } catch (e) {
          print(e);
        }
      });
    }
  }

  return 0;
}