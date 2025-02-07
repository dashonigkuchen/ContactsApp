import 'package:appwrite/appwrite.dart';
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
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _membersFilterContainer.init().then((_) => setState(() {
          loading = false;
        }));
  }

  List<String>? _generateQueries() {
    List<String> queries = <String>[];
    if (_membersFilterContainer.isHonoraryMember == true) {
      queries.add(Query.equal("isHonoraryMember", _membersFilterContainer.isHonoraryMember));
    }

    if (queries.isNotEmpty) {
      return queries;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const PopScope(
        canPop: false,
        child: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

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
                value: _membersFilterContainer.isHonoraryMember,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {});
                    _membersFilterContainer.setIsHonoraryMember(val);
                  }
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _membersFilterContainer.storeCurrentFilter();
              Navigator.of(context).pop();
              context.read<MembersCubit>().getAllMembersAndPaidMembershipFees(queries: _generateQueries());
            },
            child: const Text("Apply Filter"),
          ),
        ],
      ),
    );
  }
}
