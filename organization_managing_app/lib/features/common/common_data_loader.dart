import 'package:fpdart/fpdart.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/data/model/member_model.dart';
import 'package:organization_managing_app/data/model/member_with_paid_membership_fees.dart';
import 'package:organization_managing_app/data/provider/repository/members_repository.dart';
import 'package:organization_managing_app/data/provider/repository/paid_membership_fee_repository.dart';

class CommonDataLoader {
  final MembersRepository _membersRepository = locator<MembersRepository>();
  final PaidMembershipFeeRepository _paidMembershipFeeRepository =
      locator<PaidMembershipFeeRepository>();

  Future<Either<Failure, List<MemberWithPaidMembershipFees>>>
      getAllMembersAndPaidMembershipFees({
    List<String>? queries,
  }) async {
    final resMembers = await _membersRepository.getAllMembers(
      queries: queries,
    );
    if (resMembers.isLeft()) {
      return left(resMembers.getLeft().toNullable()!);
    }

    final resMembershipFees =
        await _paidMembershipFeeRepository.getAllPaidMembershipFees();
    if (resMembershipFees.isLeft()) {
      return left(resMembershipFees.getLeft().toNullable()!);
    }

    final membersList = resMembers.getRight().toNullable()!;
    final paidMembershipFeeList = resMembershipFees.getRight().toNullable()!;
    List<MemberWithPaidMembershipFees> memberWithPaidMembershipFeesList =
        <MemberWithPaidMembershipFees>[];
    for (MemberModel memberModel in membersList) {
      memberWithPaidMembershipFeesList.add(MemberWithPaidMembershipFees(
        memberModel: memberModel,
        paidMembershipFeeList: paidMembershipFeeList,
      ));
    }
    return right(memberWithPaidMembershipFeesList);
  }
}
