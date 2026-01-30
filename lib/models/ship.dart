enum ShipState { alive, dead }

class Ship {
  final int id;
  final String teamId;

  int hp;
  ShipState state = ShipState.alive;

  Ship({
    required this.id,
    required this.teamId,
    this.hp = 100,
  });
}
