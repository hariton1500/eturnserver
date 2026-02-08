import 'dart:async';
import 'dart:convert';
import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/models/commands.dart';
import 'package:eturnserver/models/player.dart';
import 'package:eturnserver/models/ship.dart';
import 'package:vector_math/vector_math.dart';

class Battle {
  final int id;
  final List<Player> participants;
  final List<Command> commandsQueue = [];
  final Map<int, Ship> shipsMap = {}; //key = Player.id, value = Ship
  late final Timer runTimer;

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
    }
    run();
  }


  void run() {
    Timer.periodic(Duration(milliseconds: 1000), (runTimer) {
      tick();
    });
  }

  
  void tick() {
    _executeCommand();
    _broadcastState();
  }
  
  void _executeCommand() {}
  
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
}