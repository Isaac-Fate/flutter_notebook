# String Formatting

## String Interpolation

String interpolation is the process of evaluating a string literal containing one or more placeholders, yielding a result in which the placeholders are replaced with their corresponding values.

```dart
final name = 'Isaac';
final message = 'Hello, $name';
print(message); // Hello Isaac
```

## String Formatting

Package: [format](https://pub.dev/packages/format)

### `format` Function

```dart
import 'package:format/format.dart';

// The following statements all print 'Hello, Isaac'
print(format('Hello, {}', 'Isaac'));
print(format('Hello, {}', ['Isaac']));
print(format('Hello, {0}', ['Isaac']));
```

