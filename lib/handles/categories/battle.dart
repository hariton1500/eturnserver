import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';
import 'package:eturnserver/models/commands.dart';
import 'package:eturnserver/models/player.dart';
import 'package:vector_math/vector_math.dart';

void handleBattle(Map<String, dynamic> json, Player player) {
  final String type = json['type'];
  printD('type: $type');
  switch (type) {
    case 'command':
    final String command = json['command'];
      if (command == 'move_to') {
        Vector2 target = Vector2(json['data']['x'], json['data']['y']);
        try {
          //find battle with player
          var btl = battles.firstWhere((battle) => battle.participants.contains(player));
          //find same commands presented
          var cmds = btl.commandsQueue.where((c) => c.type == CommandType.moveTo);
          if (cmds.isEmpty) {
            btl.addCommand(Command(shipId: player.activeShipId!, type: CommandType.moveTo)..targetPoint = target);
          } else {
            cmds.first.targetPoint = target;
          }
        } catch (e) {
          printD(e.toString());
        }
      }
    break;
  }
}