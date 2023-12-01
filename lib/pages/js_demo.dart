import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart';

final jsRuntime = getJavascriptRuntime();

class JsDemo extends StatefulWidget {
  const JsDemo({super.key});

  @override
  State<JsDemo> createState() => _JsDemoState();
}

class _JsDemoState extends State<JsDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JavaScript Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                jsRuntime.evaluateAsync(js).then((result) => print(result));
              },
              child: const Text('Run JS'),
            ),
          ],
        ),
      ),
    );
  }
}

const js = '''
async function hello() {
  return "hello from JS";
}

hello();
Promise.resolve(hello());
''';
