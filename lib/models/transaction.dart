import 'package:json_annotation/json_annotation.dart';
import './category.dart';
part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  /// Converts a JSON object to a [Transaction] object.
  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  /// Converts this object to a JSON object.
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
