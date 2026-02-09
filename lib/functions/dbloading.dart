import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';

Future<bool> loadingFromDB() async {
  printD('Loading from DB');
  if (sb != null) {
    List<Map<String, dynamic>> fractions = await sb!.from('fractions').select();
    printD('Loaded fractions:\n$fractions');
    shipClasses = await sb!.from('ship_classes').select();
    printD('Loaded shipTypes:\n$shipClasses');
    shipsDB = await sb!.from('ships').select();
    printD('Loaded ships:\n$shipsDB');
    List<Map<String, dynamic>> icons = await sb!.from('icons').select();
    printD('Loaded icons:\n$icons');
    List<Map<String, dynamic>> moduleGroups = await sb!.from('module_groups').select();
    printD('Loaded moduleGroups:\n$moduleGroups');
    modules = await sb!.from('modules').select();
    printD('Loaded modules:\n$modules');
    registeredUsers = await sb!.from('players').select();
    printD('Loaded registeredUsers:\n$registeredUsers');
    playersShips = await sb!.from('players_ships').select();
    printD('Loaded players ships:\n$playersShips');
    sb!.from('players_ships').stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
      playersShips = data;
    });
    playersFits = await sb!.from('players_fits').select();
    printD('Loaded players fits:\n$playersFits');
    sb!.from('players_fits').stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
      playersFits = data;
    });
    return true;
  } else {
    printD('error loading, no connection to DB');
    return false;
  }
}