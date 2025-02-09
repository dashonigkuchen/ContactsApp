import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/features/members/cubit/members_cubit.dart';
import 'package:organization_managing_app/features/members/members_filter_service.dart';

class MembersFilterPage extends StatefulWidget {
  const MembersFilterPage({super.key});

  @override
  State<MembersFilterPage> createState() => _MembersFilterPageState();
}

class _MembersFilterPageState extends State<MembersFilterPage> {
  final MembersFilterService _membersFilterService =
      locator<MembersFilterService>();
  late final MembersFilterContainer _membersFilterContainer =
      _membersFilterService.membersFilterContainer.copy();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Options"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          CheckboxListTile(
            value: _membersFilterContainer.onlyHonoraryMember,
            title: Text("Only honorary member"),
            onChanged: (val) {
              if (val != null) {
                setState(() {});
                _membersFilterContainer.onlyHonoraryMember = val;
              }
            },
          ),
          CheckboxListTile(
            value: _membersFilterContainer.onlyNotPaidMembers,
            title: Text("Only not paid member [NOT WORKING NOW]"),
            onChanged: (val) {
              if (val != null) {
                setState(() {});
                _membersFilterContainer.onlyNotPaidMembers = val;
              }
            },
          ),
          CheckboxListTile(
            value: _membersFilterContainer.onlyPaidMembers,
            title: Text("Only paid members [NOT WORKING NOW]"),
            onChanged: (val) {
              if (val != null) {
                setState(() {});
                _membersFilterContainer.onlyPaidMembers = val;
              }
            },
          ),
          CheckboxListTile(
            value: _membersFilterContainer.onlyNoPaymentNeededMembers,
            title: Text("Only no payment needed members"),
            onChanged: (val) {
              if (val != null) {
                setState(() {});
                _membersFilterContainer.onlyNoPaymentNeededMembers = val;
              }
            },
          ),
          CheckboxListTile(
            value: _membersFilterContainer.onlyBoardMembers,
            title: Text("Only board members"),
            onChanged: (val) {
              if (val != null) {
                setState(() {});
                _membersFilterContainer.onlyBoardMembers = val;
              }
            },
          ),
          CheckboxListTile(
            value: _membersFilterContainer.alsoShowDeactivatedMembers,
            title: Text("Also show deactivated members"),
            onChanged: (val) {
              if (val != null) {
                setState(() {});
                _membersFilterContainer.alsoShowDeactivatedMembers = val;
              }
            },
          ),
          CheckboxListTile(
            value: _membersFilterContainer.onlyDeactivatedMembers,
            title: Text("Only deactivated members"),
            onChanged: (val) {
              if (val != null) {
                setState(() {});
                _membersFilterContainer.onlyDeactivatedMembers = val;
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              _membersFilterService.membersFilterContainer =
                  _membersFilterContainer;
              _membersFilterService.storeCurrentFilter();
              Navigator.of(context).pop(true);
              context.read<MembersCubit>().getAllMembersAndPaidMembershipFees();
            },
            child: const Text("Apply Filter"),
          ),
        ],
      ),
    );
  }
}
