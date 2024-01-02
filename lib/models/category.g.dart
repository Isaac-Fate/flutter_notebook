// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      expenseCategory: $enumDecodeNullable(
          _$ExpenseCategoryEnumMap, json['expenseCategory']),
      incomeCategory:
          $enumDecodeNullable(_$IncomeCategoryEnumMap, json['incomeCategory']),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'expenseCategory': _$ExpenseCategoryEnumMap[instance.expenseCategory],
      'incomeCategory': _$IncomeCategoryEnumMap[instance.incomeCategory],
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.food: 'food',
  ExpenseCategory.transportation: 'transportation',
};

const _$IncomeCategoryEnumMap = {
  IncomeCategory.salary: 'salary',
  IncomeCategory.gift: 'gift',
};
