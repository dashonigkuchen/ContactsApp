// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaidMembershipFeeModel {
  final String id;
  final double amount;
  final int year;
  final DateTime paymentDate;
  PaidMembershipFeeModel({
    required this.id,
    required this.amount,
    required this.year,
    required this.paymentDate,
  });

  PaidMembershipFeeModel copyWith({
    String? id,
    double? amount,
    int? year,
    DateTime? paymentDate,
  }) {
    return PaidMembershipFeeModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      year: year ?? this.year,
      paymentDate: paymentDate ?? this.paymentDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'year': year,
      'paymentDate': paymentDate.millisecondsSinceEpoch,
    };
  }

  factory PaidMembershipFeeModel.fromMap(Map<String, dynamic> map) {
    return PaidMembershipFeeModel(
      id: map['id'] as String,
      amount: map['amount'] as double,
      year: map['year'] as int,
      paymentDate: DateTime.fromMillisecondsSinceEpoch(map['paymentDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaidMembershipFeeModel.fromJson(String source) => PaidMembershipFeeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaidMembershipFee(id: $id, amount: $amount, year: $year, paymentDate: $paymentDate)';
  }

  @override
  bool operator ==(covariant PaidMembershipFeeModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.amount == amount &&
      other.year == year &&
      other.paymentDate == paymentDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      amount.hashCode ^
      year.hashCode ^
      paymentDate.hashCode;
  }
}
