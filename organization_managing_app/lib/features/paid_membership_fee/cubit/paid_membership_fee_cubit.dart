import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/data/model/member_model.dart';
import 'package:organization_managing_app/data/model/paid_membership_fee_model.dart';
import 'package:organization_managing_app/data/provider/repository/members_repository.dart';
import 'package:organization_managing_app/data/provider/repository/paid_membership_fee_repository.dart';

part 'paid_membership_fee_state.dart';

class PaidMembershipFeeCubit extends Cubit<PaidMembershipFeeState> {
  final PaidMembershipFeeRepository _paidMembershipFeeRepository =
      locator<PaidMembershipFeeRepository>();
  final MembersRepository _membersRepository = locator<MembersRepository>();

  PaidMembershipFeeCubit() : super(PaidMembershipFeeInitial());

  void addPaidMembershipFee({
    required PaidMembershipFeeModel paidMembershipFeeModel,
  }) async {
    emit(PaidMembershipFeeLoading());

    final res = await _paidMembershipFeeRepository.addPaidMembershipFee(
      paidMembershipFeeModel: paidMembershipFeeModel,
    );

    res.fold((failure) => emit(PaidMembershipFeeError(failure: failure)),
        (document) => emit(PaidMembershipFeeSuccess()));
  }

  void getAllPaidMembershipFees({
    List<String>? queries,
  }) async {
    emit(PaidMembershipFeeLoading());

    final resMembers = await _membersRepository.getAllMembers(
      queries: queries,
    );
    final resMembershipFees =
        await _paidMembershipFeeRepository.getAllPaidMembershipFees();

    if (resMembers.isLeft() || resMembershipFees.isLeft()) {
      emit(PaidMembershipFeeError(
        failure: resMembers.isLeft()
            ? resMembers.getLeft().toNullable()!
            : resMembershipFees.getLeft().toNullable()!,
      ));
    } else {
      final membersList = resMembers.getRight().toNullable()!;
      final paidMembershipFeeList = resMembershipFees.getRight().toNullable()!;
      emit(PaidMembershipFeeFetchSuccess(
          membersList: membersList,
          paidMembershipFeeList: paidMembershipFeeList));
    }
  }

  void editMembershipFee({
    required PaidMembershipFeeModel paidMembershipFeeModel,
  }) async {
    emit(PaidMembershipFeeLoading());

    final res = await _paidMembershipFeeRepository.editPaidMembershipFee(
      paidMembershipFeeModel: paidMembershipFeeModel,
    );

    res.fold((failure) => emit(PaidMembershipFeeError(failure: failure)),
        (document) => emit(PaidMembershipFeeSuccess()));
  }

  void deleteMembershipFee({
    required PaidMembershipFeeModel paidMembershipFeeModel,
  }) async {
    emit(PaidMembershipFeeLoading());

    final res = await _paidMembershipFeeRepository.deleteMembershipFee(
      documentId: paidMembershipFeeModel.id,
    );

    res.fold((failure) => emit(PaidMembershipFeeError(failure: failure)),
        (document) => emit(PaidMembershipFeeSuccess()));
  }
}
