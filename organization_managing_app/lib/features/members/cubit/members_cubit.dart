import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/data/model/member_model.dart';
import 'package:organization_managing_app/data/model/member_with_paid_membership_fees.dart';
import 'package:organization_managing_app/data/provider/repository/members_repository.dart';
import 'package:organization_managing_app/data/provider/repository/paid_membership_fee_repository.dart';
import 'package:organization_managing_app/features/common/common_data_loader.dart';
import 'package:organization_managing_app/features/members/members_filter_container.dart';

part 'members_state.dart';

class MembersCubit extends Cubit<MembersState> {
  final MembersRepository _membersRepository = locator<MembersRepository>();
  final PaidMembershipFeeRepository _paidMembershipFeeRepository =
      locator<PaidMembershipFeeRepository>();
  final CommonDataLoader _commonDataLoader = locator<CommonDataLoader>();
  final MembersFilterContainer _membersFilterContainer =
      locator.get<MembersFilterContainer>();

  MembersCubit() : super(MembersInitial());

  void addMember({
    required MemberModel memberModel,
  }) async {
    emit(MembersLoading());

    final res = await _membersRepository.addMember(
      memberModel: memberModel,
    );

    res.fold((failure) => emit(MembersError(failure: failure)),
        (document) => emit(MembersAddEditDeleteSuccess()));
  }

  void getAllMembersAndPaidMembershipFees() async {
    emit(MembersLoading());

    final res = await _commonDataLoader.getAllMembersAndPaidMembershipFees(
      queries: _membersFilterContainer.generateQueries(),
    );

    res.fold(
        (failure) => emit(MembersError(failure: failure)),
        (memberWithPaidMembershipFeesList) => emit(MembersFetchSuccess(
            memberWithPaidMembershipFeesList:
                memberWithPaidMembershipFeesList)));
  }

  void editMember({
    required MemberModel memberModel,
  }) async {
    emit(MembersLoading());

    final res = await _membersRepository.editMember(
      memberModel: memberModel,
    );

    res.fold((failure) => emit(MembersError(failure: failure)),
        (document) => emit(MembersAddEditDeleteSuccess()));
  }

  void deleteMember({
    required MemberModel memberModel,
  }) async {
    emit(MembersLoading());

    final resMembers = await _membersRepository.deleteMember(
      documentId: memberModel.id,
    );
    final resMembershipFees =
        await _paidMembershipFeeRepository.deletePaidMembershipFeesOfMember(
      memberId: memberModel.id,
    );

    if (resMembers.isLeft() || resMembershipFees.isLeft()) {
      emit(MembersError(
        failure: resMembers.isLeft()
            ? resMembers.getLeft().toNullable()!
            : resMembershipFees.getLeft().toNullable()!,
      ));
    } else {
      emit(MembersAddEditDeleteSuccess());
    }
  }
}
