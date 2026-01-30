import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';

Future<bool> loadingFromDB() async {
  printD('Loading from DB');
  if (sb != null) {
    List<Map<String, dynamic>> fractions = await sb!.from('fractions').select();
    printD('Loaded fractions:\n$fractions');
    List<Map<String, dynamic>> shipTypes = await sb!.from('ship_types').select();
    printD('Loaded shipTypes:\n$shipTypes');
    List<Map<String, dynamic>> ships = await sb!.from('ships').select();
    printD('Loaded ships:\n$ships');
    List<Map<String, dynamic>> icons = await sb!.from('icons').select();
    printD('Loaded icons:\n$icons');
    List<Map<String, dynamic>> moduleGroups = await sb!.from('module_groups').select();
    printD('Loaded moduleGroups:\n$moduleGroups');
    List<Map<String, dynamic>> modules = await sb!.from('modules').select();
    printD('Loaded modules:\n$modules');
    registeredUsers = await sb!.from('players').select();
    printD('Loaded registeredUsers:\n$registeredUsers');
    printD('Data loaded.');
    return true;
  } else {
    printD('error loading, no connection to DB');
    return false;
  }
}