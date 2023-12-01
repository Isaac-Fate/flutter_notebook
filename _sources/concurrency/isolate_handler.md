# Isolate Handler

Package: isolate_handler: ^1.0.2

The isolates spawned by this package *can* call platform plugins.

## Get One Message

Let's create a simple isolate that sends a message to the main isolate.

First, create an isolate handler:

```dart
final isolateHandler = IsolateHandler();
```

An isolate can be spawned by calling `isolateHandler.spawn`.
Then function to pass to `spawn` must have the signature `void Function(Map<String, dynamic>)`.

Create a function to send a message to the main isolate:


```dart
void generateOneMessage(Map<String, dynamic> context) {
  // Creaate a messenger to communicate with the main isolate
  // by using the context that is passed to the isolate
  final messenger = HandledIsolate.initialize(context);

  // Send a message to the main isolate
  messenger.send('Hello from a separate isolate!');
}
```

Spawn the isolate:

```dart
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
```

## Process Fundamental object

Function to process data, simply increase a number by 1:


```dart
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
```

Spawn an isolate:

```dart
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
```

## Process Custom Object

Suppose you have a custom object `User`:

```dart
class User {
  final String name;
  int age;

  User(this.name, this.age);
}
```

And suppose you want to increment the age of the user in a separate isolate.

The function to process the custom object:

```dart
void processCustomObject(Map<String, dynamic> context) {
  // Creaate a messenger to communicate with the main isolate
  // by using the context that is passed to the isolate
  final messenger = HandledIsolate.initialize(context);

  // Receive the data from the main isolate
  // and process it
  messenger.listen((user) {
    // Increment the age of the user
    user.age += 1;

    // Send the modified JSON back to the main isolate
    messenger.send(user);
  });
}
```

You might want to spwan an isolate like this:

```dart
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
            User('Isaac', 24),
            to: 'processCustomObject',
        );
    },
);
```

Unfortunately, this does not work!

It seems that you cannot send a custom object to an isolate using this package.

The workaround is to convert the custom object to a JSON object before sending it to an isolate.
And in the spawned isolate, you need to parse the JSON to the custom object, process it, and then convert it back to JSON to send it back to the main isolate.

Function to process the custom object:

```dart
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
```

Spawn an isolate:

```dart
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
            // Need to convert to JSON!!!
            User('Isaac', 24).toJson(),
            to: 'processCustomObject',
        );
    },
);
```
