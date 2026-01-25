import 'dart:io';

class Player {
  final String id;
  final WebSocket socket;

  String? teamId;
  bool ready = false;

  Player({
    required this.id,
    required this.socket,
  });
}
