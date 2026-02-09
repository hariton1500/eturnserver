import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:eturnserver/functions/funcs.dart';
import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';
import 'package:eturnserver/models/commands.dart';
import 'package:eturnserver/models/player.dart';
import 'package:eturnserver/models/ship.dart';
import 'package:vector_math/vector_math.dart';

class Battle {
  final int id;
  final List<Player> participants;
  final List<Command> commandsQueue = [];
  final Map<int, Map<String, dynamic>> shipsMap = {}; //key = Player.id, value = ship
  late final Timer runTimer;
  final dt = Duration(milliseconds: 1000);

  Battle(this.id, {required this.participants}) {
    printD('Creating new battle...');
    int c = -1;
    for (var player in participants) {
      player.category = Categories.inBattle;
      player.team = c;
      player.pos = Vector2(c * 50000, c * 100);
      c *= -1;
      player.socket.add(jsonEncode({
        'category': 'battle',
        'type': 'start'
      }));
      //add players ship to shipsMap
      //Ship ship = Ship(id: id);
      Map<String, dynamic> playersShip = playersShips.firstWhere((s) => s['id'] == player.activeShipId);
      Map<String, dynamic> playersFit = playersFits.firstWhere((f) => f['players_ship_id'] == playersShip['id']);
      Map<String, dynamic> shipDB = shipsDB.firstWhere((s) => s['id'] == playersShip['ship_id']);
      Map<String, dynamic> ship = {'players_ship': playersShip, 'players_fit': playersFit, 'ship_DB': shipDB};
      calculateShip(ship);
      shipsMap[player.id] = ship;
    }
    run();
  }


  void run() {
    Timer.periodic(dt, (runTimer) {
      tick();
    });
  }

  
  void tick() {
    _executeCommands();
    _broadcastState();
  }
  
  void _executeCommands() {
    for (var command in commandsQueue) {
      switch (command.type) {
        case CommandType.moveTo:
          //updateShipState(shipsMap[command.shipId]['targetPoint'] = command.targetPoint);
          break;
        default:
      }
    }
  }
  
  void _broadcastState() {
    for (var player in participants) {
      player.category = Categories.inBattle;
      final Map<String, dynamic> dataToSend = {
        'category': 'battle',
        'type': 'state',
        'data': participants.map((p) => p.toMap()).toList()
      };
      printD('Sending to $player:\n$dataToSend');
      player.socket.add(jsonEncode(dataToSend));
    }
  }

  void addCommand(Command command) {
    commandsQueue.add(command);
  }
  
  void updateShipState(Ship ship) {
    var serverTick = dt.inMilliseconds / 1000;
    if (ship.targetPoint == null) return;
    final toTarget = ship.targetPoint! - ship.position;
    //final distance = toTarget.length;

    // ===== ПОВОРОТ =====
    final desiredAngle = atan2(toTarget.y, toTarget.x);
    final delta = shortestAngle(ship.angle, desiredAngle);

    ship.angle += delta.clamp(
      -ship.turnRate * serverTick,
      ship.turnRate * serverTick,
    );

    final forward = Vector2(cos(ship.angle), sin(ship.angle));
    ship.velocity += forward * ship.acceleration * serverTick;

    if (ship.velocity.length > ship.maxSpeed) {
      ship.velocity.scale(ship.maxSpeed);
    }

    ship.position += ship.velocity * serverTick;

  }
}