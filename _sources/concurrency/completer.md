# Completer

## Waiting for a Variable to Be Set

Sometimes, you need to wait for a variable, say `x`, to be set by other procedures, and then perform some actions based on the value of `x`. But you don't know when `x` will be available. In this case, you can use a completer to wait for `x` to be set.

In the following example, we will create a variable `message` which will be set in 1 second. We will use a completer to wait for `message` to be set. When we are waiting, a circular progress indicator will be shown, and when `message` is set, its content will be shown.

```dart
import 'dart:async';
import 'package:flutter/material.dart';

// A completer for a string
final messageCompleter = Completer<String>();

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  // The message to display
  String? _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
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
```