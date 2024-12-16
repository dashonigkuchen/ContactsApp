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
  MemberModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.birthDate,
    this.entryDate,
    required this.isHonoraryMember,
  });

  MemberModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? birthDate,
    DateTime? entryDate,
    bool? isHonoraryMember,
  }) {
    return MemberModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      entryDate: entryDate ?? this.entryDate,
      isHonoraryMember: isHonoraryMember ?? this.isHonoraryMember,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'birthDate': birthDate?.toString(),
      'entryDate': entryDate?.toString(),
      'isHonoraryMember': isHonoraryMember,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      birthDate: map['birthDate'] != null ? DateTime.parse(map['birthDate'] as String) : null,
      entryDate: map['entryDate'] != null ? DateTime.parse(map['entryDate'] as String) : null,
      isHonoraryMember:  map['isHonoraryMember'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) => MemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MemberModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, birthDate: $birthDate, entryDate: $entryDate, isHonoraryMember: $isHonoraryMember)';
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
      other.isHonoraryMember == isHonoraryMember;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      birthDate.hashCode ^
      entryDate.hashCode ^
      isHonoraryMember.hashCode;
  }
}
