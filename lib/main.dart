import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_page.dart';

abstract class WebSocket {
  Stream<int> getCounterStream();
}

class FakeWebSocket implements WebSocket {
  @override
  Stream<int> getCounterStream() async* {
    int i = 0;
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield i++;
    }
  }
}

final webSocketProvider = Provider((ref) => FakeWebSocket());

final counterProvider = StreamProvider<int>((ref) {
  final ws = ref.watch(webSocketProvider);
  return ws.getCounterStream();
});
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          surface: const Color(0xFF003909),
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
