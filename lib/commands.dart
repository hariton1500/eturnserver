enum CommandType {
  attack,
  hold,
}

class Command {
  final String shipId;
  final CommandType type;
  final String? targetId;

  Command({
    required this.shipId,
    required this.type,
    this.targetId,
  });
}
