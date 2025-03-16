import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'expense.g.dart';

@JsonSerializable(explicitToJson: true)
class Expense {
  final String id;
  final String description;
  final double amount;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime date;
  final String paidBy;
  final String splitWith;

  const Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.paidBy,
    required this.splitWith,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  static DateTime _dateTimeFromTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp _dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  // Helper method to create from Firestore
  factory Expense.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Expense.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  // Helper method to get Firestore data
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Remove id as Firestore manages this
    return json;
  }
} 