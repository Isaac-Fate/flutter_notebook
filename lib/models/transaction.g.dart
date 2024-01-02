// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'title': instance.title,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'category': instance.category.toJson(),
    };
