// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: Expense._dateTimeFromTimestamp(json['date'] as Timestamp),
      paidBy: json['paidBy'] as String,
      splitWith: json['splitWith'] as String,
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'date': Expense._dateTimeToTimestamp(instance.date),
      'paidBy': instance.paidBy,
      'splitWith': instance.splitWith,
    };
