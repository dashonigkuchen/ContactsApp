part of 'members_cubit.dart';

sealed class MembersState {}

final class MembersInitial extends MembersState {}

final class MembersLoading extends MembersState {}

final class MembersAddEditDeleteSuccess extends MembersState {}

final class MembersFetchSuccess extends MembersState {
  final List<MemberWithPaidMembershipFees> memberWithPaidMembershipFeesList;

  MembersFetchSuccess({
    required this.memberWithPaidMembershipFeesList,
  });
}

final class MembersError extends MembersState {
  final Failure failure;

  MembersError({
    required this.failure,
  });
}
