# Orientation Modes


Suppose you have two pages: the home page and a camera page with a camera preview. In some applications, you might want the camera page to be displayed only in landscape mode. To achieve this, you can use `SystemChrome.setPreferredOrientations` to set the orientations before building the widget.

Define a `Future` property, `_initializationFuture`, to store the result of `SystemChrome.setPreferredOrientations` and also other initialization steps, and initialize it in the `initState` method. 

Then, in the `build` method, use a `FutureBuilder` to build the widget only when the future is completed.

```dart
@override
void initState() {
    super.initState();

    // Initialize the widget starting by
    // setting the orientation to landscape
    _initializationFuture = SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
    ]).then((_) => availableCameras()
        // Get a list of available cameras
        .then((cameras) => _cameras = cameras)

        // Set up camera controller
        .then((_) => _controller = CameraController(
                _cameras.length <= 1 ? _cameras[0] : _cameras[1],
                ResolutionPreset.medium,
            ))

        // Initialize the camera controller
        .then((_) => _controller.initialize()));
}
```

### Disposal

Don't forget to restore the orientation to portrait mode when the widget is disposed.

```dart
@override
void dispose() {
    // Restore the orientation to portrait mode
    // when the widget is disposed
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
    ]);

    // Dispose camera controller
    _controller.dispose();

    // Dispose the widget
    super.dispose();
}
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final List<CameraDescription> _cameras;
  late final CameraController _controller;
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the widget starting by
    // setting the orientation to landscape
    _initializationFuture = SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).then((_) => availableCameras()
        // Get a list of available cameras
        .then((cameras) => _cameras = cameras)

        // Set up camera controller
        .then((_) => _controller = CameraController(
              _cameras.length <= 1 ? _cameras[0] : _cameras[1],
              ResolutionPreset.medium,
            ))

        // Initialize the camera controller
        .then((_) => _controller.initialize()));
  }

  @override
  void dispose() {
    // Restore the orientation to portrait mode
    // when the widget is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Dispose camera controller
    _controller.dispose();

    // Dispose the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Camera Page'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              body: Row(
                children: [
                  CameraPreview(_controller),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
```
