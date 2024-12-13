import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/data/model/member_model.dart';
import 'package:organization_managing_app/appwrite/members/members_repository.dart';

part 'members_state.dart';

class MembersCubit extends Cubit<MembersState> {
  final MembersRepository _membersRepository = locator<MembersRepository>();

  MembersCubit() : super(MembersInitial());

  void getAllMembers() async {
    emit(MembersLoading());

    final res = await _membersRepository.getAllMembers();

    res.fold((failure) => emit(MembersError(failure: failure)),
        (membersList) => emit(MembersFetchSuccess(membersList: membersList)));
  }
}
