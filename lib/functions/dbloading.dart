import 'package:eturnserver/functions/printing.dart';
import 'package:eturnserver/globals.dart';

Future<bool> loadingFromDB() async {
  printD('Loading from DB');
  if (sb != null) {
    List<Map<String, dynamic>> fractions = await sb!.from('fractions').select();
    List<Map<String, dynamic>> shipTypes = await sb!.from('ship_types').select();
    List<Map<String, dynamic>> ships = await sb!.from('ships').select();
    List<Map<String, dynamic>> icons = await sb!.from('icons').select();
    List<Map<String, dynamic>> moduleGroups = await sb!.from('module_groups').select();
    List<Map<String, dynamic>> modules = await sb!.from('modules').select();
    printD('Data loaded.');
    return true;
  } else {
    printD('error loading, no connection to DB');
    return false;
  }
}