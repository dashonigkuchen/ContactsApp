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
  final String? streetWithHouseNumber;
  final String? city;
  final int? postalCode;
  final String? phoneNumber;
  final String? gender;
  final String? boardFunction;
  MemberModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.birthDate,
    this.entryDate,
    required this.isHonoraryMember,
    this.noMembershipFeeNeededReason,
    this.streetWithHouseNumber,
    this.city,
    this.postalCode,
    this.phoneNumber,
    this.gender,
    this.boardFunction,
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
    String? streetWithHouseNumber,
    String? city,
    int? postalCode,
    String? phoneNumber,
    String? gender,
    String? boardFunction,
  }) {
    return MemberModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      entryDate: entryDate ?? this.entryDate,
      isHonoraryMember: isHonoraryMember ?? this.isHonoraryMember,
      noMembershipFeeNeededReason:
          noMembershipFeeNeededReason ?? this.noMembershipFeeNeededReason,
      streetWithHouseNumber:
          streetWithHouseNumber ?? this.streetWithHouseNumber,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      boardFunction: boardFunction ?? this.boardFunction,
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
      'streetWithHouseNumber': streetWithHouseNumber,
      'city': city,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'boardFunction': boardFunction,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      birthDate: map['birthDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthDate'] as int)
          : null,
      entryDate: map['entryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['entryDate'] as int)
          : null,
      isHonoraryMember: map['isHonoraryMember'] as bool,
      noMembershipFeeNeededReason: map['noMembershipFeeNeededReason'] != null
          ? map['noMembershipFeeNeededReason'] as String
          : null,
      streetWithHouseNumber: map['streetWithHouseNumber'] != null
          ? map['streetWithHouseNumber'] as String
          : null,
      city: map['city'] != null ? map['city'] as String : null,
      postalCode: map['postalCode'] != null ? map['postalCode'] as int : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      boardFunction:
          map['boardFunction'] != null ? map['boardFunction'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) =>
      MemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MemberModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, birthDate: $birthDate, entryDate: $entryDate, isHonoraryMember: $isHonoraryMember, noMembershipFeeNeededReason: $noMembershipFeeNeededReason, streetWithHouseNumber: $streetWithHouseNumber, city: $city, postalCode: $postalCode, phoneNumber: $phoneNumber, gender: $gender, boardFunction: $boardFunction)';
  }

  @override
  bool operator ==(covariant MemberModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.birthDate == birthDate &&
        other.entryDate == entryDate &&
        other.isHonoraryMember == isHonoraryMember &&
        other.noMembershipFeeNeededReason == noMembershipFeeNeededReason &&
        other.streetWithHouseNumber == streetWithHouseNumber &&
        other.city == city &&
        other.postalCode == postalCode &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender &&
        other.boardFunction == boardFunction;
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
        noMembershipFeeNeededReason.hashCode ^
        streetWithHouseNumber.hashCode ^
        city.hashCode ^
        postalCode.hashCode ^
        phoneNumber.hashCode ^
        gender.hashCode ^
        boardFunction.hashCode;
  }
}

bool isMembershipFeePaymentNeeded(MemberModel memberModel) {
  return !memberModel.isHonoraryMember &&
      (memberModel.noMembershipFeeNeededReason == null ||
          memberModel.noMembershipFeeNeededReason!.isEmpty);
}
