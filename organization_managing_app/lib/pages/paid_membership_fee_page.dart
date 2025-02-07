import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';
import 'package:organization_managing_app/data/model/member_model.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/data/model/member_with_paid_membership_fees.dart';
import 'package:organization_managing_app/features/paid_membership_fee/cubit/paid_membership_fee_cubit.dart';
import 'package:organization_managing_app/pages/common/app_navigation_drawer.dart';
import 'package:intl/date_symbol_data_local.dart';

class PaidMembershipFeePage extends StatefulWidget {
  const PaidMembershipFeePage({super.key});

  @override
  State<PaidMembershipFeePage> createState() => _PaidMembershipFeePageState();
}

class _PaidMembershipFeePageState extends State<PaidMembershipFeePage> {
  @override
  void initState() {
    initializeDateFormatting('de_DE', null).then((_) => context
        .read<PaidMembershipFeeCubit>()
        .getAllMembersAndPaidMembershipFees());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paid Membership Fees"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list,
            ),
            onPressed: () {
              //context.pushNamed(RouteNames.filterMembers);
            },
          )
        ],
      ),
      drawer: const AppNavigationDrawer(),
      body: BlocBuilder<PaidMembershipFeeCubit, PaidMembershipFeeState>(
        builder: (context, state) {
          if (state is PaidMembershipFeeLoading) {
            CustomCircularLoader.show(context);
          } else if (state is PaidMembershipFeeFetchSuccess) {
            CustomCircularLoader.cancel(context);
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<PaidMembershipFeeCubit>()
                    .getAllMembersAndPaidMembershipFees();
              },
              child: state.paidMembershipFeeList.isNotEmpty
                  ? ListView.builder(
                      itemCount: state.paidMembershipFeeList.length,
                      itemBuilder: (context, index) {
                        final paidMembershipFee =
                            state.paidMembershipFeeList[index];
                        final memberWithPaidMembershipFee =
                            state.memberWithPaidMembershipFeesList.firstWhere(
                          (element) =>
                              element.memberModel.id ==
                              paidMembershipFee.memberId,
                          orElse: () => MemberWithPaidMembershipFees(
                            memberModel: MemberModel(
                              id: "-1",
                              firstName: "-1",
                              lastName: "-1",
                              isHonoraryMember: false,
                              active: false,
                            ),
                            paidMembershipFeeList: null,
                          ),
                        );
                        final member = memberWithPaidMembershipFee.memberModel;
                        return ListTile(
                          onTap: () => context.pushNamed(
                            RouteNames.addEditDeletePaidMembershipFee,
                            extra: [
                              paidMembershipFee.memberId,
                              "${member.firstName} ${member.lastName}",
                              paidMembershipFee,
                            ],
                          ),
                          title: Text("${member.firstName} ${member.lastName}"),
                          subtitle: Text(
                              "MB ${paidMembershipFee.year} paid on ${DateFormat.yMMMMd('de_DE').format(paidMembershipFee.paymentDate)}"),
                        );
                      },
                    )
                  : CustomScrollView(
                      slivers: <Widget>[
                        SliverFillRemaining(
                          child: const Center(
                            child: Text("No data found"),
                          ),
                        ),
                      ],
                    ),
            );
          } else if (state is PaidMembershipFeeError) {
            CustomCircularLoader.cancel(context);
            return Center(
              child: Text(
                state.failure.createFailureString(
                  context: context,
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
