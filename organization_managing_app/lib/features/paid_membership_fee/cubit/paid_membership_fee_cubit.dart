import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/data/model/paid_membership_fee_model.dart';
import 'package:organization_managing_app/data/provider/repository/paid_membership_fee_repository.dart';

part 'paid_membership_fee_state.dart';

class PaidMembershipFeeCubit extends Cubit<PaidMembershipFeeState> {
  final PaidMembershipFeeRepository _paidMembershipFeeRepository =
      locator<PaidMembershipFeeRepository>();

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
}
