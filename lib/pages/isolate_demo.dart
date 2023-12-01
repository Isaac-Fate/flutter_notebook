import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';
import 'package:isolate_handler/isolate_handler.dart';
import '../models/user.dart';

final logger = Logger();

final isolateHandler = IsolateHandler();

class IsolateDemo extends StatefulWidget {
  const IsolateDemo({super.key});

  @override
  State<IsolateDemo> createState() => _IsolateDemoState();
}

class _IsolateDemoState extends State<IsolateDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            // buildEchoDemo(Future(
            //   () {
            //     startEchoIsolate();
            //   },
            // )),
            buildIsolateHandlerDemo(),
          ],
        ),
      ),
    );
  }

  Widget buildEchoDemo(Future future) {
    return FutureBuilder(
      future: future,
      builder: ((context, snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ? ElevatedButton(
                  onPressed: () {},
                  child: const Text('Echo'),
                )
              : const CircularProgressIndicator()),
    );
  }

  Widget buildIsolateHandlerDemo() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            isolateHandler.spawn(
              generateOneMessage,
              name: 'generateOneMessage',
              onReceive: (message) {
                // Print the message received from the isolate
                logger.d('Received message: $message');

                // Kill the isolate after receiving the message
                isolateHandler.kill('generateOneMessage');
              },
            );
          },
          child: const Text('Get One Message'),
        ),
        ElevatedButton(
          onPressed: () {
            isolateHandler.spawn(
              processData,
              name: 'processData',
              onReceive: (data) {
                // Print the processed data from the isolate
                logger.d('Processed data: $data');

                // Kill the isolate after receiving the message
                isolateHandler.kill('processData');
              },
              onInitialized: () {
                // Send the data to an isolate to process
                isolateHandler.send(0.0, to: 'processData');
              },
            );
          },
          child: const Text('Process Data'),
        ),
        ElevatedButton(
          onPressed: () {
            isolateHandler.spawn(
              callJs,
              name: 'callJs',
              onReceive: (result) {
                // Print the processed data from the isolate
                logger.d('Result of JavaScript: $result');

                // Kill the isolate after receiving the message
                isolateHandler.kill('callJs');
              },
              onInitialized: () {
                // Send the data to an isolate to process
                isolateHandler.send(0.0, to: 'callJs');
              },
            );
          },
          child: const Text('Call JavaScript'),
        ),
        Card(
          child: Column(
            children: [
              const Text('Long-Term Communication'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      isolateHandler.spawn(
                        callJs,
                        name: 'processData',
                        onReceive: (data) {
                          // Print the data received from the processing isolate
                          logger.d('Received data: $data');
                        },
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.green),
                    child: const Text('Spawn'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      isolateHandler.send(100.0, to: 'processData');
                    },
                    child: const Text('Send'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      isolateHandler.kill('processData');
                    },
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Kill'),
                  ),
                ],
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            isolateHandler.spawn(
              processCustomObject,
              name: 'processCustomObject',
              onReceive: (user) {
                // Print the processed data from the isolate
                logger.d('Processed data: $user');

                // Kill the isolate after receiving the message
                isolateHandler.kill('processCustomObject');
              },
              onInitialized: () {
                // Send the data to an isolate to process
                isolateHandler.send(
                  User('Isaac', 24).toJson(),
                  to: 'processCustomObject',
                );
              },
            );
          },
          child: const Text('Process Custom Object'),
        ),
      ],
    );
  }
}

startEchoIsolate() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(echo, receivePort.sendPort);

  late final SendPort sendPort;

  receivePort.listen((message) =>
      message is SendPort ? sendPort = message : print('received: $message'));
}

echo(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  sleep(const Duration(milliseconds: 1000));
  sendPort.send('hello?');
}

void generateOneMessage(Map<String, dynamic> context) {
  // Creaate a messenger to communicate with the main isolate
  // by using the context that is passed to the isolate
  final messenger = HandledIsolate.initialize(context);

  // Sleep for 1 second to simulate a long-running task
  sleep(const Duration(milliseconds: 1000));

  // Send a message to the main isolate
  messenger.send('Hello from a separate isolate!');
}

void processData(Map<String, dynamic> context) {
  // Creaate a messenger to communicate with the main isolate
  // by using the context that is passed to the isolate
  final messenger = HandledIsolate.initialize(context);

  // Sleep for 1 second to simulate a long-running task
  sleep(const Duration(milliseconds: 1000));

  // Receive the data from the main isolate
  // and process it
  messenger.listen((data) {
    final processedData = data + 1;
    messenger.send(processedData);
  });
}

void callJs(Map<String, dynamic> context) async {
  // Creaate a messenger to communicate with the main isolate
  // by using the context that is passed to the isolate
  final messenger = HandledIsolate.initialize(context);

  // Create headless web view
  late final InAppWebViewController webViewController;
  final headlessWebView = HeadlessInAppWebView(
    initialData: InAppWebViewInitialData(data: '<html></html>'),
    onWebViewCreated: (controller) {
      logger.i('A headless web view is created for calling JavaScript');
      webViewController = controller;
    },
    onConsoleMessage: (controller, consoleMessage) {
      logger.d('[web console] $consoleMessage');
    },
  );

  // Run the headless web view
  // to activate the controller
  await headlessWebView.run();

  // Receive the data from the main isolate
  // and process it using JavaScript
  messenger.listen((data) async {
    final result = await webViewController.callAsyncJavaScript(
      functionBody: '''
      console.log("Hello from JavaScript");
      console.log("Data from the root isolate:", data);
      return data + 10;
      ''',
      arguments: {'data': data},
    );
    final resultValue = result!.value;
    messenger.send(resultValue);
  });
}

void createLongLivingIsolate() {
  isolateHandler.spawn(
    processData,
    name: 'processData',
    onReceive: (data) {
      // Print the data received from the processing isolate
      logger.d('Received data: $data');
    },
    onInitialized: () {
      // Send the data to an isolate to process
      isolateHandler.send(0.0, to: 'processData');
    },
  );
}

void processCustomObject(Map<String, dynamic> context) {
  // Creaate a messenger to communicate with the main isolate
  // by using the context that is passed to the isolate
  final messenger = HandledIsolate.initialize(context);

  // Receive the data from the main isolate
  // and process it
  messenger.listen((userJson) {
    // Convert the JSON to a User object
    final user = User.fromJson(userJson);

    // Increment the age of the user
    user.age += 1;

    // Convert the User object back to JSON
    final modifiedUserJson = user.toJson();

    // Send the modified JSON back to the main isolate
    messenger.send(modifiedUserJson);
  });
}
