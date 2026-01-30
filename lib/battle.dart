import 'dart:async';
import 'dart:convert';

import 'package:eturnserver/commands.dart';
import 'package:eturnserver/models/lobby.dart';
import 'package:eturnserver/models/ship.dart';

class BattleSession {
  final String id;

  final Map<String, Ship> ships = {};
  final List<Command> commandQueue = [];

  bool paused = false;

  BattleSession(this.id);

  void addShip(Ship ship) {
    //ships[ship.id] = ship;
  }

  void addCommand(Command command) {
    commandQueue.add(command);
  }

  void tick() {
    if (paused) return;

    for (final command in commandQueue) {
      _executeCommand(command);
    }

    commandQueue.clear();
  }

  void _executeCommand(Command command) {
    final ship = ships[command.shipId];
    if (ship == null || ship.state == ShipState.dead) return;

    if (command.type == CommandType.attack) {
      final target = ships[command.targetId];
      if (target == null || target.state == ShipState.dead) return;

      target.hp -= 20;

      if (target.hp <= 0) {
        target.state = ShipState.dead;
        _addScore(ship.teamId);
      }
    }
  }

  void _addScore(String teamId) {
    print('Очко команде $teamId');
  }
}


void broadcastBattleState(BattleSession battle) {
  final state = {
    'paused': battle.paused,
    'ships': battle.ships.values.map((s) => {
      'id': s.id,
      'team': s.teamId,
      'hp': s.hp,
      'state': s.state.name,
    }).toList(),
  };

  // здесь отправка всем клиентам
}

void broadcastLobbyState(Lobby lobby) {
  final state = {
    'type': 'lobby_state',
    'locked': lobby.locked,
    'players': lobby.players.values.map((p) => {
      'id': p.id,
      'team': p.teamId,
      'ready': p.ready,
    }).toList(),
  };

  for (final p in lobby.players.values) {
    p.socket.add(jsonEncode(state));
  }
}

BattleSession startBattleFromLobby(Lobby lobby) {
  lobby.locked = true;

  final battle = BattleSession('battle-${lobby.id}');

  for (final player in lobby.players.values) {
    battle.addShip(
      Ship(
        id: player.id,
        teamId: player.teamId!,
      ),
    );
  }

  return battle;
}

void startBattleLoop(BattleSession battle) {
  Timer.periodic(const Duration(seconds: 1), (_) {
    battle.tick();
    broadcastBattleState(battle);
  });
}
