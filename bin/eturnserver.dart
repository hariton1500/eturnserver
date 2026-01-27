import 'package:eturnserver/eturnserver.dart' as eturnserver;
import 'package:supabase/supabase.dart';

void main(List<String> arguments) {
  print('[${DateTime.now()}] Starting server...');
  try {
    var sbClient = SupabaseClient(
      'https://vohfzpwxwoeamiwvxqgi.supabase.co',
      $sbkey,
    );
    sbClient.from('ships').select('*').then(print);
    sbClient.dispose();
  } catch (e) {
    print(e);
  }
  //eturnserver.startServer(sbClient);
}
