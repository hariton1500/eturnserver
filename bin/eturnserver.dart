import 'package:eturnserver/eturnserver.dart' as eturnserver;

void main(List<String> arguments) {
  print('[${DateTime.now()}] Starting server...');
  eturnserver.startServer();
}
