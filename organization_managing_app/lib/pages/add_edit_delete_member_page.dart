import 'package:appwrite/appwrite.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';
import 'package:organization_managing_app/features/members/cubit/members_cubit.dart';
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
  late String _id;
  late TextEditingController _firstNameTextController,
      _lastNameTextController,
      _emailTextController,
      _noMembershipFeeNeededReasonController;
  late DateTime? _birthDate, _entryDate;
  late bool _isHonoraryMember;
  late String _noMembershipFeeNeededReason;

  @override
  void initState() {
    super.initState();

    _id = widget.memberModel?.id ?? ID.unique();
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
    _isHonoraryMember = widget.memberModel?.isHonoraryMember ?? false;
    _noMembershipFeeNeededReasonController = TextEditingController(
      text: widget.memberModel?.noMembershipFeeNeededReason ?? "",
    );
    _noMembershipFeeNeededReason =
        widget.memberModel?.noMembershipFeeNeededReason ?? "";
  }

  @override
  void dispose() {
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
    _emailTextController.dispose();
    _noMembershipFeeNeededReasonController.dispose();

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
    _noMembershipFeeNeededReasonController.clear();
    _noMembershipFeeNeededReason = "";
  }

  void _submit() {
    if (_addEditDeleteMemberFormKey.currentState!.validate()) {
      final memberModel = MemberModel(
        id: _id,
        firstName: _firstNameTextController.text,
        lastName: _lastNameTextController.text,
        email:
            _emailTextController.text == "" ? null : _emailTextController.text,
        birthDate: _birthDate,
        entryDate: _entryDate,
        isHonoraryMember: _isHonoraryMember,
        noMembershipFeeNeededReason: _noMembershipFeeNeededReason == ""
            ? null
            : _noMembershipFeeNeededReason,
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Are you sure to delete?"),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.read<MembersCubit>().deleteMember(
                                  memberModel: widget.memberModel!,
                                );
                          },
                          child: const Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Is honorary member?"),
                      Checkbox(
                        value: _isHonoraryMember,
                        onChanged: (val) => setState(() {
                          _isHonoraryMember = val!;
                        }),
                      ),
                    ],
                  ),
                  if (!_isHonoraryMember)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Custom reason to exclude membership fee"),
                        ElevatedButton(
                          onPressed: () async {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Custom reason to exclude member from membership fee"),
                                    content: TextField(
                                      controller:
                                          _noMembershipFeeNeededReasonController,
                                      autofocus: true,
                                      onChanged: (value) => setState(
                                        () {},
                                      ),
                                      decoration: InputDecoration(
                                          suffix:
                                              _noMembershipFeeNeededReasonController
                                                          .text ==
                                                      ""
                                                  ? null
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _noMembershipFeeNeededReasonController
                                                              .text = "";
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.clear,
                                                        color:
                                                            AppColor.greyColor,
                                                      ),
                                                    )),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              _noMembershipFeeNeededReasonController
                                                  .text);
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  );
                                });
                              },
                            ).then(
                              (reason) {
                                setState(() {
                                  if (reason != null) {
                                    _noMembershipFeeNeededReason = reason;
                                  } else {
                                    _noMembershipFeeNeededReasonController
                                        .text = _noMembershipFeeNeededReason;
                                  }
                                });
                              },
                            );
                          },
                          child: Icon(_noMembershipFeeNeededReason == ""
                              ? Icons.add
                              : Icons.change_circle),
                        ),
                      ],
                    ),
                  if (!_isAdd() && !_isHonoraryMember && _noMembershipFeeNeededReason.isEmpty)
                    ElevatedButton.icon(
                      onPressed: () => context.pushNamed(
                        RouteNames.addPaidMembershipFee,
                        extra: _id,
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text("Add paid membership fee"),
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
