part of 'members_cubit.dart';

sealed class MembersState {}

final class MembersInitial extends MembersState {}

final class MembersLoading extends MembersState {}

final class MembersAddEditDeleteSuccess extends MembersState {}

final class MembersFetchSuccess extends MembersState {
  final List<MemberModel> membersList;
  final List<PaidMembershipFeeModel> paidMembershipFeeList;

  MembersFetchSuccess({
    required this.membersList,
    required this.paidMembershipFeeList,
  });
}

final class MembersError extends MembersState {
  final Failure failure;

  MembersError({
    required this.failure,
  });
}
