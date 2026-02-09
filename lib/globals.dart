import 'package:eturnserver/models/battle.dart';
import 'package:eturnserver/models/player.dart';
import 'package:supabase/supabase.dart';

SupabaseClient? sb;

List<Map<String, dynamic>> registeredUsers = [];

//active players
List<Player> players = [];

//
List<Map<String, dynamic>> shipsDB = [], shipClasses = [], playersShips = [], playersFits = [], modules = [];

//active battles;
List<Battle> battles = [];
