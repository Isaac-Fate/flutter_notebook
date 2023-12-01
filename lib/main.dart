import 'package:flutter/material.dart';
import './pages/home_page.dart';
import './pages/isolate_demo.dart';
import './pages/js_demo.dart';

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
        '/isolate-demo': (context) => const IsolateDemo(),
        '/js-demo': (context) => const JsDemo(),
      },
    );
  }
}
