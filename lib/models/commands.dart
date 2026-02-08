import 'package:vector_math/vector_math.dart';

enum CommandType {
  moveTo,
  hold,
}

class Command {
  final int shipId;
  final CommandType type;
  Vector2? targetPoint;

  Command({
    required this.shipId,
    required this.type,
  });
}
