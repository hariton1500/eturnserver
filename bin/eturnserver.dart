import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:eturnserver/eturnserver.dart' as eturnserver;
import 'package:supabase/supabase.dart';


void main(List<String> arguments) async {
  print('[${DateTime.now()}] Starting server...');
  //await dotenv.load(fileName: "secrets.env");
  final dotEnv = DotEnv();
  print(dotEnv.exists());
  final key = dotEnv.getDotEnv()['key'];
  final url = dotEnv.getDotEnv()['url'];
  final sb = SupabaseClient(url!, key!);
  eturnserver.startServer(sb);
}
