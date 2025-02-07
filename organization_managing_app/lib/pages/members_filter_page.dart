import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/features/members/cubit/members_cubit.dart';
import 'package:organization_managing_app/features/members/members_filter_container.dart';

class MembersFilterPage extends StatefulWidget {
  const MembersFilterPage({super.key});

  @override
  State<MembersFilterPage> createState() => _MembersFilterPageState();
}

class _MembersFilterPageState extends State<MembersFilterPage> {
  final MembersFilterContainer _membersFilterContainer =
      locator<MembersFilterContainer>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Options"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Only honorary member"),
              Checkbox(
                value: _membersFilterContainer.onlyHonoraryMember,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {});
                    _membersFilterContainer.onlyHonoraryMember = val;
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Only not paid member [NOT WORKING NOW]"),
              Checkbox(
                value: _membersFilterContainer.onlyNotPaidMembers,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {});
                    _membersFilterContainer.onlyNotPaidMembers = val;
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Only paid members [NOT WORKING NOW]"),
              Checkbox(
                value: _membersFilterContainer.onlyPaidMembers,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {});
                    _membersFilterContainer.onlyPaidMembers = val;
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Only no payment needed members"),
              Checkbox(
                value: _membersFilterContainer.onlyNoPaymentNeededMembers,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {});
                    _membersFilterContainer.onlyNoPaymentNeededMembers = val;
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Only board members"),
              Checkbox(
                value: _membersFilterContainer.onlyBoardMembers,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {});
                    _membersFilterContainer.onlyBoardMembers = val;
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Also show deactivated members"),
              Checkbox(
                value: _membersFilterContainer.alsoShowDeactivatedMembers,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {});
                    _membersFilterContainer.alsoShowDeactivatedMembers = val;
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Only deactivated members"),
              Checkbox(
                value: _membersFilterContainer.onlyDeactivatedMembers,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {});
                    _membersFilterContainer.onlyDeactivatedMembers = val;
                  }
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _membersFilterContainer.storeCurrentFilter();
              Navigator.of(context).pop();
              context.read<MembersCubit>().getAllMembersAndPaidMembershipFees();
            },
            child: const Text("Apply Filter"),
          ),
        ],
      ),
    );
  }
}
