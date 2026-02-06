import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:eturnserver/models/commands.dart';
import 'package:eturnserver/models/player.dart';
import 'package:eturnserver/models/ship.dart';
import 'package:vector_math/vector_math.dart';

class Battle {
  final int id;
  final List<Player> participants;
  final List<Command> commandsQueue = [];
  final Map<int, Ship> shipsMap = {}; //key = Player.id, value = Ship

  Battle(this.id, {required this.participants}) {
    run();
    for (var participant in participants) {
      participant.category = Categories.inBattle;
      participant.team = participants.indexOf(participant).isOdd ? -1 : 1;
      participant.pos = Vector2(participant.team! * 50000, participants.indexOf(participant) * 100);
      participant.socket.add(jsonEncode({
        'category': 'battle',
        'type': 'start',
        'data': {
          //'team': participant.team,
          //'pos': {'x': participant.pos?.x, 'y': participant.pos?.y},
          'ships': participants.map((p) => p.toMap()).toList()
        }
      }));
    }
  }


  void run() {
    Timer.periodic(Duration(milliseconds: 1000), (_) {tick();});
  }

  
  void tick() {
    _executeCommand();
    _broadcastState();
  }
  
  void _executeCommand() {}
  
  void _broadcastState() {}

  void addCommand(Command command) {
    commandsQueue.add(command);
  }
}