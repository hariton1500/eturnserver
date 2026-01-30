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
    players[playerId]?.teamId = teamId;
  }

  void setReady(String playerId, bool value) {
    players[playerId]?.ready = value;
  }

  bool get allReady =>
      players.isNotEmpty &&
      players.values.every((p) => p.ready && p.teamId != null);
}

void autoAssignTeams(Lobby lobby) {
  final teamA = 'A';
  final teamB = 'B';

  int toggle = 0;

  for (final player in lobby.players.values) {
    player.teamId = toggle % 2 == 0 ? teamA : teamB;
    toggle++;
  }
}
