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
    run();
    for (var participant in participants) {
      participant.category = Categories.inBattle;
      participant.team = participants.indexOf(participant).isOdd ? -1 : 1;
      participant.pos = Vector2(participant.team! * 50000, participants.indexOf(participant) * 100);
      final Map<String, dynamic> dataToSend = {
        'category': 'battle',
        'type': 'start',
        'data': {participants.map((p) => p.toMap()).toList()}
      };
      printD('Sending to $participant:\n$dataToSend');
      participant.socket.add(jsonEncode(dataToSend));
    }
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
  
  void _broadcastState() {}

  void addCommand(Command command) {
    commandsQueue.add(command);
  }
}