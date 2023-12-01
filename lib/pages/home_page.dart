import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notebook'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/isolate-demo'),
                child: const Text('Isolates'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/js-demo'),
                child: const Text('JavaScript Demo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
