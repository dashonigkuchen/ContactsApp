import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';
import 'package:organization_managing_app/features/members/cubit/members_cubit.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
      ),
      body: BlocBuilder<MembersCubit, MembersState>(
        builder: (context, state) {
          if (state is MembersLoading) {
            CustomCircularLoader.show(context);
          } else if (state is MembersFetchSuccess) {
            CustomCircularLoader.cancel(context);
            return state.membersList.isNotEmpty
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
                      );
                    },
                  )
                : const Center(
                    child: Text("No data found"),
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