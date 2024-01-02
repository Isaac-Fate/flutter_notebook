import 'package:flutter/material.dart';

class JsonSerializationDemo extends StatefulWidget {
  const JsonSerializationDemo({super.key});

  @override
  State<JsonSerializationDemo> createState() => _JsonSerializationDemoState();
}

class _JsonSerializationDemoState extends State<JsonSerializationDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Serialization Demo'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
