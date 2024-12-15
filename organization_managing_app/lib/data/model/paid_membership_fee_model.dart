// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaidMembershipFeeModel {
  final String id;
  final double amount;
  final int year;
  final DateTime paymentDate;
  final String memberId;
  PaidMembershipFeeModel({
    required this.id,
    required this.amount,
    required this.year,
    required this.paymentDate,
    required this.memberId,
  });

  PaidMembershipFeeModel copyWith({
    String? id,
    double? amount,
    int? year,
    DateTime? paymentDate,
    String? memberId,
  }) {
    return PaidMembershipFeeModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      year: year ?? this.year,
      paymentDate: paymentDate ?? this.paymentDate,
      memberId: memberId ?? this.memberId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'year': year,
      'paymentDate': paymentDate.toString(),
      'memberId': memberId,
    };
  }

  factory PaidMembershipFeeModel.fromMap(Map<String, dynamic> map) {
    final amount = map['amount'] as num;
    return PaidMembershipFeeModel(
      id: map['id'] as String,
      amount: amount.toDouble(),
      year: map['year'] as int,
      paymentDate: DateTime.parse(map['paymentDate'] as String),
      memberId: map['memberId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaidMembershipFeeModel.fromJson(String source) => PaidMembershipFeeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaidMembershipFeeModel(id: $id, amount: $amount, year: $year, paymentDate: $paymentDate, memberId: $memberId)';
  }

  @override
  bool operator ==(covariant PaidMembershipFeeModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.amount == amount &&
      other.year == year &&
      other.paymentDate == paymentDate &&
      other.memberId == memberId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      amount.hashCode ^
      year.hashCode ^
      paymentDate.hashCode ^
      memberId.hashCode;
  }
}
