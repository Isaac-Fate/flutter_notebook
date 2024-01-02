import 'dart:async';
import 'package:flutter/material.dart';

// A completer for a string
final messageCompleter = Completer<String>();

class CompleterDemo extends StatefulWidget {
  const CompleterDemo({super.key});

  @override
  State<CompleterDemo> createState() => _CompleterDemoState();
}

class _CompleterDemoState extends State<CompleterDemo> {
  // The message to display
  String? _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completer Demo'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Set the message
                    _message = 'Hello World';
                  });
                  // Complete the future
                  messageCompleter.complete(_message);
                },
                child: const Text('Set Message'),
              ),

              // Check if the future is completed
              messageCompleter.isCompleted
                  // If it is completed, show the message
                  ? Text('Message: $_message')

                  // Show a progress indicator if the future is not completed
                  : const CircularProgressIndicator(),
            ],
          ),
        ],
      )),
    );
  }
}
