import 'package:appwrite/appwrite.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/appwrite/members/cubit/members_cubit.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/core/widgets/custom_snackbar.dart';
import 'package:organization_managing_app/core/widgets/custom_text_form_field.dart';
import 'package:organization_managing_app/data/model/member_model.dart';

class AddEditDeleteMemberPage extends StatefulWidget {
  final MemberModel? memberModel;
  const AddEditDeleteMemberPage({
    super.key,
    this.memberModel,
  });

  @override
  State<AddEditDeleteMemberPage> createState() =>
      _AddEditDeleteMemberPageState();
}

class _AddEditDeleteMemberPageState extends State<AddEditDeleteMemberPage> {
  final _addEditDeleteMemberFormKey = GlobalKey<FormState>();
  late TextEditingController _firstNameTextController,
      _lastNameTextController,
      _emailTextController;
  late DateTime? _birthDate, _entryDate;

  @override
  void initState() {
    super.initState();

    _firstNameTextController = TextEditingController(
      text: widget.memberModel?.firstName ?? "",
    );
    _lastNameTextController = TextEditingController(
      text: widget.memberModel?.lastName ?? "",
    );
    _emailTextController = TextEditingController(
      text: widget.memberModel?.email ?? "",
    );
    _birthDate = widget.memberModel?.birthDate;
    _entryDate = widget.memberModel?.entryDate;
  }

  @override
  void dispose() {
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
    _emailTextController.dispose();

    super.dispose();
  }

  bool _isAdd() {
    return widget.memberModel == null;
  }

  void _reset() {
    _addEditDeleteMemberFormKey.currentState!.reset();
    _firstNameTextController.clear();
    _lastNameTextController.clear();
    _emailTextController.clear();
  }

  void _submit() {
    if (_addEditDeleteMemberFormKey.currentState!.validate()) {
      final memberModel = MemberModel(
        id: _isAdd() ? ID.unique() : widget.memberModel!.id,
        firstName: _firstNameTextController.text,
        lastName: _lastNameTextController.text,
        email: _emailTextController.text == "" ? null : _emailTextController.text,
        birthDate: _birthDate,
        entryDate: _entryDate,
      );

      if (_isAdd()) {
        context.read<MembersCubit>().addMember(memberModel: memberModel);
      } else {
        context.read<MembersCubit>().editMember(memberModel: memberModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdd() ? "Add Member" : "Edit Member"),
        actions: [
          if (!_isAdd())
            IconButton(
              onPressed: () {
                //_deleteTodo(
                //  documentId: widget.todoModel!.id,
                //);
              },
              icon: const Icon(
                Icons.delete,
                color: AppColor.whiteColor,
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<MembersCubit, MembersState>(
          listener: (context, state) {
            if (state is MembersLoading) {
              CustomCircularLoader.show(context);
            } else if (state is MembersAddEditDeleteSuccess) {
              _reset();
              CustomCircularLoader.cancel(context);
              CustomSnackbar.showSuccess(
                context,
                "Success",
              );
              context.pop();
              context.read<MembersCubit>().getAllMembers();
            } else if (state is MembersError) {
              CustomCircularLoader.cancel(context);
              CustomSnackbar.showError(
                context,
                state.failure.createFailureString(
                  context: context,
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _addEditDeleteMemberFormKey,
              child: ListView(
                children: [
                  CustomTextFormField(
                    controller: _firstNameTextController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obsecureText: false,
                    labelText: "First Name",
                    suffix: null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _lastNameTextController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obsecureText: false,
                    labelText: "Last Name",
                    suffix: null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _emailTextController,
                    validator: (val) {
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    obsecureText: false,
                    labelText: "Email",
                    suffix: null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DateTimeFormField(
                    onChanged: (dateTime) {
                      setState(() {
                        _birthDate = dateTime;
                      });
                    },
                    mode: DateTimeFieldPickerMode.date,
                    decoration: const InputDecoration(
                      labelText: "Birth Date",
                      helperText: "YYYY/MM/DD",
                    ),
                    initialValue: _birthDate,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DateTimeFormField(
                    onChanged: (dateTime) {
                      setState(() {
                        _entryDate = dateTime;
                      });
                    },
                    mode: DateTimeFieldPickerMode.date,
                    decoration: const InputDecoration(
                      labelText: "Entry Date",
                      helperText: "YYYY/MM/DD",
                    ),
                    initialValue: _entryDate,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
