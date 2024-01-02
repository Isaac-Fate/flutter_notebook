import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category {
  final ExpenseCategory? expenseCategory;
  final IncomeCategory? incomeCategory;

  Category({
    this.expenseCategory,
    this.incomeCategory,
  });

  /// Converts a JSON object to a [Category] object.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  /// Converts this object to a JSON object.
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

enum ExpenseCategory {
  food,
  transportation,
}

enum IncomeCategory {
  salary,
  gift,
}
