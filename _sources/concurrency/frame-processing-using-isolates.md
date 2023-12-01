# Using Isolates for Frame Processing in Flutter

In this code, we're using Dart's Isolate to process frames from a camera feed in a separate thread. This is done to offload the heavy computation from the main UI thread and keep the app responsive.

## Starting the Isolate

The isolate is started in the startFrameProcessingIsolate function. This function creates a ReceivePort and spawns a new isolate that runs the processFrames function. The ReceivePort's SendPort is passed to the new isolate so that it can send messages back to the main isolate.

```dart
Future<Isolate> startFrameProcessingIsolate(
  Stream<CameraImage> frameStream, {
  Function? onReceivedData,
}) async {
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawn(processFrames, receivePort.sendPort);
  ...
  return isolate;
}
```

## Communicating with the Isolate

The main isolate listens for messages from the new isolate using receivePort.listen. The first message it receives should be the SendPort of the new isolate, which it stores in sendPort. This SendPort is used to send frames to the new isolate.

```dart
receivePort.listen((message) {
  if (message is SendPort) {
    sendPort = message;
  } else {
    onReceivedData?.call(message) ?? logger.d('Received message: $message');
  }
});
```

The main isolate also listens for frames from the camera feed using frameStream.listen and sends each frame to the new isolate using sendPort.send.

```dart
frameStream.listen((frame) {
  sendPort.send(frame);
});
```

## Processing Frames in the Isolate

The processFrames function is run in the new isolate. It creates a ReceivePort and sends its SendPort back to the main isolate. It then listens for frames from the main isolate using receivePort.listen.

```dart
void processFrames(SendPort sendPort) async {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  ...
  receivePort.listen((frame) async {
    ...
    sendPort.send(image);
  });
}
```

Each frame is processed and the result is sent back to the main isolate using sendPort.send.

Receiving Processed Frames in the Main Isolate
Back in the main isolate, the receivePort.listen callback also handles the processed frames that are sent back from the new isolate. If a Function called onReceivedData is provided, it's called with the processed frame. Otherwise, the processed frame is logged.

```dart
receivePort.listen((message) {
  if (message is SendPort) {
    sendPort = message;
  } else {
    onReceivedData?.call(message) ?? logger.d('Received message: $message');
  }
});
```

## Stopping the Isolate

When the VideoPoseDetection widget is disposed, the isolate is also killed using _frameProcessingIsolate.kill(). This stops the frame processing and frees up resources.

```dart
void dispose() {
  _frameProcessingIsolate.kill();
  _controller.dispose();
  super.dispose();
}
```

This approach allows for efficient processing of camera frames without blocking the main UI thread, leading to a smoother user experience.