  import 'dart:convert';
import 'dart:math';

import 'package:eturnserver/globals.dart';

double shortestAngle(double a, double b) {
    double diff = (b - a + pi) % (2 * pi) - pi;
    return diff < -pi ? diff + 2 * pi : diff;
  }


void calculateShip(Map<String, dynamic> ship) {
  String json = ship['players_fit']['med'];
  Map<String, dynamic> fittedInMed = jsonDecode(json);
  for (int moduleId in fittedInMed.values) {
    Map<String, dynamic> module = modules.firstWhere((m) => m['id'] == moduleId);
    json = module['passive'];
    Map<String, dynamic> pasModulesData = jsonDecode(json);
    for (var pasData in pasModulesData.entries) {
      String parametrName = pasData.key;
      if (pasData.value['+*'] == '+') {
        ship['shipDB'][parametrName] += pasData.value['value'];
      } else {
        ship['shipDB'][parametrName] *= pasData.value['value'];
      }
    }
  }
}