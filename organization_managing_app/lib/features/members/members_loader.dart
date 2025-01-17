import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/features/members/cubit/members_cubit.dart';

class MembersLoader {
  static void load(
    BuildContext context, {
    List<String>? queries,
  }) {
    context.read<MembersCubit>().getAllMembers(
          queries: queries,
        );
  }
}
