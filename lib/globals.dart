import 'package:eturnserver/models/player.dart';
import 'package:supabase/supabase.dart';

SupabaseClient? sb;

Map<String, String> registeredUsers = {
  'h@h.com': '123',
};

//active players
List<Player> players = [];