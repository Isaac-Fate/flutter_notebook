import 'package:flutter/material.dart';
import './pages/home_page.dart';
import './pages/isolate_demo.dart';
import './pages/js_demo.dart';
import './pages/json_serialization_demo.dart';
import './pages/completer_demo.dart';
import './pages/custom_paint_demo.dart';
import './pages/fundamentals.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/fundamentals': (context) => const FoundamentalsDemo(),
        '/json-serialization-demo': (context) => const JsonSerializationDemo(),
        '/isolate-demo': (context) => const IsolateDemo(),
        '/js-demo': (context) => const JsDemo(),
        '/completer-demo': (context) => const CompleterDemo(),
        '/custom-paint-demo': (context) => const CustomPaintDemo(),
      },
    );
  }
}
