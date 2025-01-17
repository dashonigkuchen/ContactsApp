// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MemberModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final DateTime? birthDate;
  final DateTime? entryDate;
  final bool isHonoraryMember;
  final String? noMembershipFeeNeededReason;
  MemberModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.birthDate,
    this.entryDate,
    required this.isHonoraryMember,
    this.noMembershipFeeNeededReason,
  });

  MemberModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? birthDate,
    DateTime? entryDate,
    bool? isHonoraryMember,
    String? noMembershipFeeNeededReason,
  }) {
    return MemberModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      entryDate: entryDate ?? this.entryDate,
      isHonoraryMember: isHonoraryMember ?? this.isHonoraryMember,
      noMembershipFeeNeededReason: noMembershipFeeNeededReason ?? this.noMembershipFeeNeededReason,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'entryDate': entryDate?.millisecondsSinceEpoch,
      'isHonoraryMember': isHonoraryMember,
      'noMembershipFeeNeededReason': noMembershipFeeNeededReason,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      birthDate: map['birthDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['birthDate'] as int) : null,
      entryDate: map['entryDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['entryDate'] as int) : null,
      isHonoraryMember: map['isHonoraryMember'] as bool,
      noMembershipFeeNeededReason: map['noMembershipFeeNeededReason'] != null ? map['noMembershipFeeNeededReason'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) => MemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MemberModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, birthDate: $birthDate, entryDate: $entryDate, isHonoraryMember: $isHonoraryMember, noMembershipFeeNeededReason: $noMembershipFeeNeededReason)';
  }

  @override
  bool operator ==(covariant MemberModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.birthDate == birthDate &&
      other.entryDate == entryDate &&
      other.isHonoraryMember == isHonoraryMember &&
      other.noMembershipFeeNeededReason == noMembershipFeeNeededReason;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      birthDate.hashCode ^
      entryDate.hashCode ^
      isHonoraryMember.hashCode ^
      noMembershipFeeNeededReason.hashCode;
  }
}
