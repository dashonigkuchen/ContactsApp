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
