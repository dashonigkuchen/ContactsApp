part of 'paid_membership_fee_cubit.dart';

sealed class PaidMembershipFeeState {}

final class PaidMembershipFeeInitial extends PaidMembershipFeeState {}

final class PaidMembershipFeeLoading extends PaidMembershipFeeState {}

final class PaidMembershipFeeSuccess extends PaidMembershipFeeState {}

final class PaidMembershipFeeError extends PaidMembershipFeeState {
  final Failure failure;

  PaidMembershipFeeError({
    required this.failure,
  });
}

final class PaidMembershipFeeFetchSuccess extends PaidMembershipFeeState {
  final List<MemberWithPaidMembershipFees> memberWithPaidMembershipFeesList;
  late int paidMembershipFeesCount = 0;
  late List<PaidMembershipFeeModel> paidMembershipFeeList = <PaidMembershipFeeModel>[];

  PaidMembershipFeeFetchSuccess({
    required this.memberWithPaidMembershipFeesList,
  }) {
    for (MemberWithPaidMembershipFees memberWithPaidMembershipFees in memberWithPaidMembershipFeesList) {
      paidMembershipFeesCount += memberWithPaidMembershipFees.sortedPaidMembershipFeesOfMember.length;
      for (PaidMembershipFeeModel paidMembershipFeeModel in memberWithPaidMembershipFees.sortedPaidMembershipFeesOfMember) {
        paidMembershipFeeList.add(paidMembershipFeeModel);
      }
    }
  }
}
