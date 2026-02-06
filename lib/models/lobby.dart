import 'package:eturnserver/models/player.dart';

class Lobby {
  final String id;

  final Map<String, Player> players = {};
  bool locked = false;

  Lobby(this.id);

  void addPlayer(Player player) {
    if (locked) return;
    //players[player.id] = player.id;
  }

  void removePlayer(String playerId) {
    players.remove(playerId);
  }

  void setTeam(String playerId, String teamId) {
    if (locked) return;
    players[playerId]?.team = 0;
  }

  void setReady(String playerId, bool value) {
    players[playerId]?.ready = value;
  }

  bool get allReady =>
      players.isNotEmpty &&
      players.values.every((p) => p.ready && p.team != null);
}

void autoAssignTeams(Lobby lobby) {
  final teamA = -1;
  final teamB = 1;

  int toggle = 0;

  for (final player in lobby.players.values) {
    player.team = toggle % 2 == 0 ? -1 : 1;
    toggle++;
  }
}
