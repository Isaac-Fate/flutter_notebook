# Binary Search

Package: [collection](https://pub.dev/packages/collection)

In the following example, we have a list of users sorted by their age (in ascending order). 
We want to find the index of the specific user whose name is `Isaac`, and whose age is `24`.

The schema of the `User` class is as follows:

```dart
class User {
  final String name;
  final int age;

  User(this.name, this.age);
}
```

A list of users is defined as follows:

```dart
final users = [
  User('Alice', 14),
  User('Bob', 18),
  User('Chris', 20),
  User('Isaac', 24),
  User('Helen', 38),
  User('John', 45),
];
```

Using the `binarySearch` function from the `collection` package, we can find the index of the user whose name is `Isaac`:

```dart
final index = binarySearch<User, String>(
  users,
  User('Isaac', 24),
  compare: (a, b) => a.age.compareTo(b.age),
);
```

We provided a `compare` function to the `binarySearch` function, which is used to compare two users by their age.

Note that the `value` parameter of the `binarySearch` function is an instance of the `User` class.
The problem is sometimes we only know the age of the user we want to find, but we don't care about the name.

The trick is to create a dummy user with the same age, but with an empty name (or any other name):

```dart
final dummyUser = User('', 24);
// Or User('Anyone', 24) since we don't care about the name

final index = binarySearch<User, String>(
  users,
  dummyUser,
  compare: (a, b) => a.age.compareTo(b.age),
);
```
