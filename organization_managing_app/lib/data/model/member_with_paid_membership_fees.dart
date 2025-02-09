import 'package:flutter/material.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';
import 'package:organization_managing_app/data/model/member_model.dart';
import 'package:organization_managing_app/data/model/paid_membership_fee_model.dart';

class MemberWithPaidMembershipFees {
  late MemberModel memberModel;
  late List<PaidMembershipFeeModel> sortedPaidMembershipFeesOfMember = <PaidMembershipFeeModel>[];

  MemberWithPaidMembershipFees({
    required this.memberModel,
    required List<PaidMembershipFeeModel>? paidMembershipFeeList,
  }) {
    if (paidMembershipFeeList != null) {
      sortedPaidMembershipFeesOfMember = paidMembershipFeeList
          .where((element) => element.memberId == memberModel.id)
          .toList();
      sortedPaidMembershipFeesOfMember.sort((a, b) => b.year.compareTo(a.year));
    }
  }

  Text getPaidMembershipFeeStateText() {
    if (memberModel.isHonoraryMember) {
      return const Text(
        "Honorary Member",
        style: TextStyle(
          color: AppColor.snackBarGreen,
        ),
      );
    } else if (memberModel.noMembershipFeeNeededReason != null &&
        memberModel.noMembershipFeeNeededReason!.isNotEmpty) {
      return Text(
        memberModel.noMembershipFeeNeededReason!,
        style: const TextStyle(
          color: AppColor.snackBarGreen,
        ),
      );
    } else if (sortedPaidMembershipFeesOfMember.elementAtOrNull(0) != null) {
      if (sortedPaidMembershipFeesOfMember.elementAt(0).year == DateTime.now().year) {
        return Text(
          "Paid for ${sortedPaidMembershipFeesOfMember.elementAt(0).year.toString()}",
          style: const TextStyle(
            color: AppColor.snackBarGreen,
          ),
        );
      } else {
        return Text(
          "Last paid for ${sortedPaidMembershipFeesOfMember.elementAt(0).year.toString()}",
          style: const TextStyle(
            color: AppColor.snackBarRed,
          ),
        );
      }
    }

    return const Text(
      "Not paid yet",
      style: TextStyle(
        color: AppColor.snackBarRed,
      ),
    );
  }
}
