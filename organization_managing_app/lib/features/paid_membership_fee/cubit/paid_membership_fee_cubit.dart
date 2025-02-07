import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/data/model/member_with_paid_membership_fees.dart';
import 'package:organization_managing_app/data/model/paid_membership_fee_model.dart';
import 'package:organization_managing_app/data/provider/repository/paid_membership_fee_repository.dart';
import 'package:organization_managing_app/features/common/common_data_loader.dart';

part 'paid_membership_fee_state.dart';

class PaidMembershipFeeCubit extends Cubit<PaidMembershipFeeState> {
  final PaidMembershipFeeRepository _paidMembershipFeeRepository =
      locator<PaidMembershipFeeRepository>();
  final CommonDataLoader _commonDataLoader = locator<CommonDataLoader>();

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

  void getAllMembersAndPaidMembershipFees({
    List<String>? queries,
  }) async {
    emit(PaidMembershipFeeLoading());

    final res = await _commonDataLoader.getAllMembersAndPaidMembershipFees(
      queries: queries,
    );

    res.fold(
        (failure) => emit(PaidMembershipFeeError(failure: failure)),
        (memberWithPaidMembershipFeesList) => emit(PaidMembershipFeeFetchSuccess(
            memberWithPaidMembershipFeesList:
                memberWithPaidMembershipFeesList)));
  }

  void editPaidMembershipFee({
    required PaidMembershipFeeModel paidMembershipFeeModel,
  }) async {
    emit(PaidMembershipFeeLoading());

    final res = await _paidMembershipFeeRepository.editPaidMembershipFee(
      paidMembershipFeeModel: paidMembershipFeeModel,
    );

    res.fold((failure) => emit(PaidMembershipFeeError(failure: failure)),
        (document) => emit(PaidMembershipFeeSuccess()));
  }

  void deletePaidMembershipFee({
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
