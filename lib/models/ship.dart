import 'package:vector_math/vector_math.dart';

enum ShipState { alive, dead }

class Ship {
  final int id;
  
  String? teamId;
  Vector2? targetPoint;
  Vector2 position = Vector2.zero();
  double angle = 0, turnRate = 0, acceleration = 0, maxSpeed = 0;
  Vector2 velocity = Vector2.zero();

  int hp;
  ShipState state = ShipState.alive;



  Ship({
    required this.id,
    this.hp = 100,
  });
}
