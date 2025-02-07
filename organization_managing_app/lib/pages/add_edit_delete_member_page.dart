import 'package:appwrite/appwrite.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/core/widgets/custom_snackbar.dart';
import 'package:organization_managing_app/core/widgets/custom_text_form_field.dart';
import 'package:organization_managing_app/data/model/member_model.dart';
import 'package:organization_managing_app/data/model/member_with_paid_membership_fees.dart';
import 'package:organization_managing_app/data/model/paid_membership_fee_model.dart';
import 'package:organization_managing_app/features/members/cubit/members_cubit.dart';

class AddEditDeleteMemberPage extends StatefulWidget {
  final MemberWithPaidMembershipFees? originalMemberWithLatestPaidMembershipFee;
  const AddEditDeleteMemberPage({
    super.key,
    this.originalMemberWithLatestPaidMembershipFee,
  });

  @override
  State<AddEditDeleteMemberPage> createState() =>
      _AddEditDeleteMemberPageState();
}

class _AddEditDeleteMemberPageState extends State<AddEditDeleteMemberPage> {
  final _memberDetailFormKey = GlobalKey<FormState>();
  late final MemberWithPaidMembershipFees _memberWithLatestPaidMembershipFee =
      widget.originalMemberWithLatestPaidMembershipFee ??
          MemberWithPaidMembershipFees(
            memberModel: MemberModel(
              id: ID.unique(),
              firstName: "",
              lastName: "",
              isHonoraryMember: false,
              active: true,
            ),
            paidMembershipFeeList: null,
          );
  late bool _isAdd = false, _isEdit = false;
  late bool _dataChanged = false, _isExit = false;
  late TextEditingController _firstNameTextEditingController,
      _lastNameTextEditingController,
      _emailTextEditingController,
      _streetAndHouseNumberTextEditingController,
      _postalCodeTextEditingController,
      _cityTextEditingController,
      _phoneNumberTextEditingController,
      _boardFunctionTextEditingController,
      _noMembershipFeeNeededReasonTextEditingController;
  late DateTime? _birthDate, _entryDate;
  late bool _isHonoraryMember, _membershipState;
  late String? _gender;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting('de_DE', null);

    _isAdd = widget.originalMemberWithLatestPaidMembershipFee == null;

    _firstNameTextEditingController = TextEditingController(
      text: _memberWithLatestPaidMembershipFee.memberModel.firstName,
    );
    _lastNameTextEditingController = TextEditingController(
      text: _memberWithLatestPaidMembershipFee.memberModel.lastName,
    );
    _emailTextEditingController = TextEditingController(
      text: _memberWithLatestPaidMembershipFee.memberModel.email,
    );
    _streetAndHouseNumberTextEditingController = TextEditingController(
      text:
          _memberWithLatestPaidMembershipFee.memberModel.streetWithHouseNumber,
    );
    _postalCodeTextEditingController = TextEditingController(
      text:
          _memberWithLatestPaidMembershipFee.memberModel.postalCode?.toString(),
    );
    _cityTextEditingController = TextEditingController(
      text: _memberWithLatestPaidMembershipFee.memberModel.city,
    );
    _phoneNumberTextEditingController = TextEditingController(
      text: _memberWithLatestPaidMembershipFee.memberModel.phoneNumber,
    );
    _boardFunctionTextEditingController = TextEditingController(
      text: _memberWithLatestPaidMembershipFee.memberModel.boardFunction,
    );
    _noMembershipFeeNeededReasonTextEditingController = TextEditingController(
      text: _memberWithLatestPaidMembershipFee
          .memberModel.noMembershipFeeNeededReason,
    );

    _birthDate = _memberWithLatestPaidMembershipFee.memberModel.birthDate;
    _entryDate = _memberWithLatestPaidMembershipFee.memberModel.entryDate;

    _isHonoraryMember =
        _memberWithLatestPaidMembershipFee.memberModel.isHonoraryMember;
    _membershipState = _memberWithLatestPaidMembershipFee.memberModel.active;

    _gender = _memberWithLatestPaidMembershipFee.memberModel.gender;
  }

  @override
  void dispose() {
    _firstNameTextEditingController.dispose();
    _lastNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _streetAndHouseNumberTextEditingController.dispose();
    _postalCodeTextEditingController.dispose();
    _cityTextEditingController.dispose();
    _phoneNumberTextEditingController.dispose();
    _boardFunctionTextEditingController.dispose();
    _noMembershipFeeNeededReasonTextEditingController.dispose();

    super.dispose();
  }

  void _submit() {
    if (_memberDetailFormKey.currentState!.validate()) {
      final memberModel = _createCurrentMemberModel();
      _memberWithLatestPaidMembershipFee.memberModel = memberModel;
      if (_isAdd) {
        context.read<MembersCubit>().addMember(memberModel: memberModel);
      } else {
        context.read<MembersCubit>().editMember(memberModel: memberModel);
      }
      _dataChanged = true;
    }
  }

  MemberModel _createCurrentMemberModel() {
    return MemberModel(
      id: _memberWithLatestPaidMembershipFee.memberModel.id,
      firstName: _firstNameTextEditingController.text,
      lastName: _lastNameTextEditingController.text,
      email: _emailTextEditingController.text == ""
          ? null
          : _emailTextEditingController.text,
      birthDate: _birthDate,
      entryDate: _entryDate,
      isHonoraryMember: _isHonoraryMember,
      noMembershipFeeNeededReason:
          _noMembershipFeeNeededReasonTextEditingController.text == ""
              ? null
              : _noMembershipFeeNeededReasonTextEditingController.text,
      streetWithHouseNumber:
          _streetAndHouseNumberTextEditingController.text == ""
              ? null
              : _streetAndHouseNumberTextEditingController.text,
      postalCode: _postalCodeTextEditingController.text == ""
          ? null
          : int.tryParse(_postalCodeTextEditingController.text),
      city: _cityTextEditingController.text == ""
          ? null
          : _cityTextEditingController.text,
      phoneNumber: _phoneNumberTextEditingController.text == ""
          ? null
          : _phoneNumberTextEditingController.text,
      gender: _gender,
      boardFunction: _boardFunctionTextEditingController.text == ""
          ? null
          : _boardFunctionTextEditingController.text,
      active: _membershipState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_dataChanged) {
          context.read<MembersCubit>().getAllMembersAndPaidMembershipFees();
        }
      },
      child: BlocListener<MembersCubit, MembersState>(
        listener: (context, state) {
          if (state is MembersLoading) {
            CustomCircularLoader.show(context);
          } else if (state is MembersAddEditDeleteSuccess) {
            CustomCircularLoader.cancel(context);
            CustomSnackbar.showSuccess(
              context,
              "Success",
            );
            if (_isExit) {
              Navigator.of(context).pop();
            }
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
        child: Form(
          key: _memberDetailFormKey,
          child: Scaffold(
            appBar: AppBar(
              title: Text(_isAdd
                  ? "Add Member"
                  : _isEdit
                      ? "Edit Member"
                      : "Member Details"),
              leading: IconButton(
                onPressed: () {
                  if (_memberWithLatestPaidMembershipFee.memberModel !=
                      _createCurrentMemberModel()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Save changes?"),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Discard changes'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Continue editing'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _isExit = true;
                                _submit();
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColor.whiteColor,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (_isAdd) {
                      _isExit = true;
                      _submit();
                    } else if (_isEdit) {
                      _submit();
                    }

                    if (!_isAdd) {
                      setState(() {
                        _isEdit = !_isEdit;
                      });
                    }
                  },
                  icon: Icon(
                    _isAdd || _isEdit ? Icons.save : Icons.edit,
                    color: AppColor.whiteColor,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _firstNameTextEditingController,
                    keyboardType: TextInputType.text,
                    labelText: "First Name",
                    readOnly: _isAdd || _isEdit ? false : true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _lastNameTextEditingController,
                    labelText: "Last Name",
                    readOnly: _isAdd || _isEdit ? false : true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (!_isAdd)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Current membership fee state:"),
                        _memberWithLatestPaidMembershipFee
                            .getPaidMembershipFeeStateText(),
                      ],
                    ),
                  if (!_isAdd)
                    const SizedBox(
                      height: 10,
                    ),
                  if (!_isAdd &&
                      !_isEdit &&
                      isMembershipFeePaymentNeeded(
                          _memberWithLatestPaidMembershipFee.memberModel))
                    ElevatedButton.icon(
                      onPressed: () async {
                        PaidMembershipFeeModel? updatedData =
                            await context.pushNamed(
                          RouteNames.addEditDeletePaidMembershipFee,
                          extra: [
                            _memberWithLatestPaidMembershipFee.memberModel.id,
                            "${_firstNameTextEditingController.text} ${_lastNameTextEditingController.text}",
                          ],
                        );

                        if (updatedData != null) {
                          setState(() {
                            _memberWithLatestPaidMembershipFee
                                .sortedPaidMembershipFeesOfMember
                                .add(updatedData);
                          });
                          _dataChanged = true;
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add paid membership fee"),
                    ),
                  if (!_isAdd &&
                      isMembershipFeePaymentNeeded(
                          _memberWithLatestPaidMembershipFee.memberModel))
                    const SizedBox(
                      height: 10,
                    ),
                  ExpansionTile(
                    title: Text(
                        "${_isAdd ? "Add" : _isEdit ? "Edit" : "See"} more member details"),
                    children: [
                      CustomTextFormField(
                        controller: _emailTextEditingController,
                        labelText: "Email",
                        readOnly: _isAdd || _isEdit ? false : true,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DateTimeFormField(
                        decoration: const InputDecoration(
                          labelText: "Birth Date",
                        ),
                        initialValue: _birthDate,
                        enabled: _isAdd || _isEdit ? true : false,
                        onChanged: (value) =>
                            setState(() => _birthDate = value),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DateTimeFormField(
                        decoration: const InputDecoration(
                          labelText: "Entry Date",
                        ),
                        initialValue: _entryDate,
                        enabled: _isAdd || _isEdit ? true : false,
                        onChanged: (value) =>
                            setState(() => _entryDate = value),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _streetAndHouseNumberTextEditingController,
                        labelText: "Street and house number",
                        readOnly: _isAdd || _isEdit ? false : true,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _postalCodeTextEditingController,
                        labelText: "Postal Code",
                        readOnly: _isAdd || _isEdit ? false : true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _cityTextEditingController,
                        labelText: "City",
                        readOnly: _isAdd || _isEdit ? false : true,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _phoneNumberTextEditingController,
                        labelText: "Phone Number",
                        readOnly: _isAdd || _isEdit ? false : true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownMenu<String?>(
                        dropdownMenuEntries: [
                          const DropdownMenuEntry(
                              value: null, label: "Not given"),
                          const DropdownMenuEntry(value: "w", label: "Female"),
                          const DropdownMenuEntry(value: "m", label: "Male"),
                        ],
                        label: Text("Gender"),
                        width: double.maxFinite,
                        initialSelection: _gender,
                        enabled: _isAdd || _isEdit ? true : false,
                        onSelected: (value) => setState(() => _gender = value),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _phoneNumberTextEditingController,
                        labelText: "Phone Number",
                        readOnly: _isAdd || _isEdit ? false : true,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _boardFunctionTextEditingController,
                        labelText: "Board function",
                        readOnly: _isAdd || _isEdit ? false : true,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownMenu<bool>(
                        dropdownMenuEntries: [
                          const DropdownMenuEntry(value: true, label: "Yes"),
                          const DropdownMenuEntry(value: false, label: "No"),
                        ],
                        label: Text("Honorary Member"),
                        width: double.maxFinite,
                        initialSelection: _isHonoraryMember,
                        enabled: _isAdd || _isEdit ? true : false,
                        onSelected: (value) =>
                            setState(() => _isHonoraryMember = value!),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (!_isHonoraryMember)
                        CustomTextFormField(
                          controller:
                              _noMembershipFeeNeededReasonTextEditingController,
                          labelText: "Custom reason to exclude membership fee",
                          readOnly: _isAdd || _isEdit ? false : true,
                          textInputAction: TextInputAction.done,
                        ),
                      if (!_isHonoraryMember)
                        const SizedBox(
                          height: 10,
                        ),
                      DropdownMenu<bool>(
                        dropdownMenuEntries: [
                          const DropdownMenuEntry(value: true, label: "Active"),
                          const DropdownMenuEntry(value: false, label: "Not active"),
                        ],
                        label: Text("Membership state"),
                        width: double.maxFinite,
                        initialSelection: _membershipState,
                        enabled: _isAdd || _isEdit ? true : false,
                        onSelected: (value) =>
                            setState(() => _membershipState = value!),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    title: Text("${_isEdit ? "Edit" : "See"} payments"),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _memberWithLatestPaidMembershipFee
                            .sortedPaidMembershipFeesOfMember.length,
                        itemBuilder: (context, index) {
                          final paidMembershipFee =
                              _memberWithLatestPaidMembershipFee
                                  .sortedPaidMembershipFeesOfMember[index];
                          return ListTile(
                            onTap: () async {
                              if (_isEdit) {
                                final updatedData = await context.pushNamed(
                                  RouteNames.addEditDeletePaidMembershipFee,
                                  extra: [
                                    paidMembershipFee.memberId,
                                    "${_firstNameTextEditingController.text} ${_lastNameTextEditingController.text}",
                                    paidMembershipFee,
                                  ],
                                );

                                if (updatedData != null) {
                                  setState(() {
                                    if (updatedData is PaidMembershipFeeModel) {
                                      _memberWithLatestPaidMembershipFee
                                              .sortedPaidMembershipFeesOfMember[
                                          index] = updatedData;
                                    } else if (updatedData is bool) {
                                      if (updatedData) {
                                        _memberWithLatestPaidMembershipFee
                                            .sortedPaidMembershipFeesOfMember
                                            .removeAt(index);
                                      }
                                    }
                                  });
                                  _dataChanged = true;
                                }
                              }
                            },
                            title: Text(
                                "MB ${paidMembershipFee.year}, ${paidMembershipFee.id}"),
                            subtitle: Text(
                                "Paid on ${DateFormat.yMMMMd('de_DE').format(paidMembershipFee.paymentDate)}"),
                            trailing:
                                Text("${paidMembershipFee.amount.toString()}€"),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
