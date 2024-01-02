import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:collection/collection.dart';
import 'package:ml_linalg/linalg.dart';
import '../models/user.dart';

class FoundamentalsDemo extends StatefulWidget {
  const FoundamentalsDemo({super.key});

  @override
  State<FoundamentalsDemo> createState() => _FoundamentalsDemoState();
}

class _FoundamentalsDemoState extends State<FoundamentalsDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fundamentals'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  print(format('Hello, {}', 'Isaac'));
                  print(format('Hello, {}', ['Isaac']));
                  print(format('Hello, {0}', ['Isaac']));
                  print('Hello, {}'.format('Isaac'));
                },
                child: const Text('Format String'),
              ),
              const Divider(height: 0),
              const ListTile(
                title: Text('Binary Search'),
                subtitle: Text(
                    'Binary search is an efficient algorithm for finding an item from a sorted list of items. It works by repeatedly dividing in half the portion of the list that could contain the item, until you\'ve narrowed down the possible locations to just one.'),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => binarySearchDemo(),
                    child: const Text('Search'),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => findFirstGreaterIndexDemo(),
                    child: const Text('Find First Greater Index'),
                  ),
                ],
              ),
              const Divider(height: 0),
              ElevatedButton(
                onPressed: () {
                  final matrix = Matrix.fromRows([
                    Vector.fromList([1, 2, 3]),
                    Vector.fromList([4, 5, 6])
                  ]);

                  print(matrix);
                  print(matrix.mean());
                },
                child: const Text('Run'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

binarySearchDemo() {
  final users = [
    User('Alice', 14),
    User('Bob', 18),
    User('Chris', 20),
    User('Isaac', 24),
    User('Helen', 38),
    User('John', 45),
  ];

  User dummyTarget = User('', 24);

  final index = binarySearch(
    users,
    dummyTarget,
    compare: (user1, user2) => user1.age.compareTo(user2.age),
  );

  print('Target Index: $index, Target user name: ${users[index].name}');
}

findFirstGreaterIndexDemo() {
  final users = [
    User('Alice', 14),
    User('Bob', 18),
    User('Chris', 20),
    User('Isaac', 24),
    User('Helen', 38),
    User('John', 45),
  ];

  User dummyTarget = User('', 15);

  final index = findFirstGreaterIndex(
    users,
    dummyTarget,
    compare: (user1, user2) => user1.age.compareTo(user2.age),
  );

  if (index == null) {
    if (users.isEmpty) {
      print('No element found.');
    } else {
      print('No greater element found.');
    }
  } else {
    print('Target Index: $index, Target user name: ${users[index].name}');
  }
}

/// Finds the first index of the item in the sorted list
/// that is greater than the given item.
/// If no such item exists, returns null.
int? findFirstGreaterIndex<E>(
  List<E> sortedList,
  E item, {
  int Function(E, E)? compare,
}) {
  if (compare == null) {
    if (E is Comparable) {
      compare = (E a, E b) => (a as Comparable).compareTo(b as Comparable);
    } else {
      throw ArgumentError(
          'Argument compare must be provided since $E is not comparable');
    }
  }

  if (sortedList.isEmpty) {
    return null;
  }

  if (compare(sortedList.first, item) > 0) {
    return 0;
  }

  if (compare(sortedList.last, item) <= 0) {
    return null;
  }

  // Now, we know that
  // sortedList.first <= item < sortedList.last

  int start = 0;
  int end = sortedList.length - 1;

  // Binary search
  while (start < end) {
    final mid = start + ((end - start) >> 1);
    final compareResult = compare(sortedList[mid], item);
    if (compareResult > 0) {
      end = mid;
    } else {
      start = mid + 1;
    }
  }

  return end;
}
