import 'dart:io';

import 'package:eturnserver/globals.dart';

enum Categories {
  justLoggedIn,
  station,
  lobby,
  tournamentroom
}

class Player {
  final int id;
  final WebSocket socket;

  Categories category = Categories.justLoggedIn; 
  String? teamId;
  bool ready = false;
  Map<String, dynamic> playerProgress = {};
  int? activeShipId;

  Player({
    required this.id,
    required this.socket,
  });

  Map<String, dynamic> toMap() {
    var shipDB = shipsDB.firstWhere((shipDB) => shipDB['id'] == activeShipId);
    var shipClass = shipClasses.firstWhere((shipClass) => shipClass['id'] == shipDB['class_id']);
    return {
      'ship_DB': shipDB,
      'ship_class': shipClass
    };
  }

  Future<void> loadFromDB() async {
    var temp = await sb!.from('player_progress').select().limit(1);
    playerProgress = temp.first;
  }

  @override
  String toString() {
    return '$id; $category';
  }
}
