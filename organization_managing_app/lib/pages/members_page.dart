import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';
import 'package:organization_managing_app/data/model/member_model.dart';
import 'package:organization_managing_app/data/model/paid_membership_fee_model.dart';
import 'package:organization_managing_app/features/members/cubit/members_cubit.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/pages/common/app_navigation_drawer.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  @override
  void initState() {
    context.read<MembersCubit>().getAllMembers();
    super.initState();
  }

  Widget? _getListTileTrailing({
    required MemberModel member,
    required List<PaidMembershipFeeModel> paidMembershipFeeList,
  }) {
    if (member.isHonoraryMember) {
      return const Text("Honorary Member",
          style: TextStyle(
            color: AppColor.snackBarGreen,
          ));
    }

    if (member.noMembershipFeeNeededReason != null && member.noMembershipFeeNeededReason!.isNotEmpty) {
      return Text(member.noMembershipFeeNeededReason!,
          style: TextStyle(
            color: AppColor.snackBarGreen,
          ));
    }

    paidMembershipFeeList.sort((a, b) => b.year.compareTo(a.year));
    final PaidMembershipFeeModel paidMembershipFee =
        paidMembershipFeeList.firstWhere(
      (element) => element.memberId == member.id,
      orElse: () => PaidMembershipFeeModel(
        id: "",
        amount: -1,
        year: -1,
        paymentDate: DateTime(-1),
        memberId: "",
      ),
    );

    if (paidMembershipFee.year < 0) {
      return const Text(
        "Not paid yet",
        style: TextStyle(
          color: AppColor.snackBarRed,
        ),
      );
    }

    return Text(
      paidMembershipFee.year.toString(),
      style: TextStyle(
        color: paidMembershipFee.year == DateTime.now().year
            ? AppColor.snackBarGreen
            : AppColor.snackBarRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list,
            ),
            onPressed: () {
              context.pushNamed(RouteNames.filterMembers);
            },
          )
        ],
      ),
      drawer: const AppNavigationDrawer(),
      drawerScrimColor: AppColor.transparentColor,
      body: BlocBuilder<MembersCubit, MembersState>(
        builder: (context, state) {
          if (state is MembersLoading) {
            CustomCircularLoader.show(context);
          } else if (state is MembersFetchSuccess) {
            CustomCircularLoader.cancel(context);
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MembersCubit>().getAllMembers();
              },
              child: state.membersList.isNotEmpty
                  ? ListView.builder(
                      itemCount: state.membersList.length,
                      itemBuilder: (context, index) {
                        final member = state.membersList[index];
                        return ListTile(
                          onTap: () => context.pushNamed(
                            RouteNames.editMember,
                            extra: member,
                          ),
                          title: Text(member.firstName),
                          subtitle: Text(member.lastName),
                          trailing: _getListTileTrailing(
                            member: member,
                            paidMembershipFeeList: state.paidMembershipFeeList,
                          ),
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
          } else if (state is MembersError) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouteNames.addMember);
        },
        backgroundColor: AppColor.appColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
