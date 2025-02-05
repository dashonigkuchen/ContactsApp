import 'package:appwrite/appwrite.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/core/widgets/custom_snackbar.dart';
import 'package:organization_managing_app/core/widgets/custom_text_form_field.dart';
import 'package:organization_managing_app/data/model/paid_membership_fee_model.dart';
import 'package:organization_managing_app/features/paid_membership_fee/cubit/paid_membership_fee_cubit.dart';

class AddEditDeletePaidMembershipFeePage extends StatefulWidget {
  final String memberId;
  final String name;
  final PaidMembershipFeeModel? paidMembershipFeeModel;
  const AddEditDeletePaidMembershipFeePage({
    super.key,
    required this.memberId,
    required this.name,
    required this.paidMembershipFeeModel,
  });

  @override
  State<AddEditDeletePaidMembershipFeePage> createState() =>
      _AddEditDeletePaidMembershipFeePageState();
}

class _AddEditDeletePaidMembershipFeePageState
    extends State<AddEditDeletePaidMembershipFeePage> {
  final _addPaidMembershipFeeFormKey = GlobalKey<FormState>();
  final CurrencyTextInputFormatter _currencyTextInputFormatter =
      CurrencyTextInputFormatter.currency(
    locale: "de",
    decimalDigits: 0,
    symbol: "€",
  );
  final TextEditingController _amountTextController = TextEditingController();
  late DateTime _paymentDate = DateTime.now();
  late int _year = DateTime.now().year;

  bool _isAdd() {
    return widget.paidMembershipFeeModel == null;
  }

  @override
  void initState() {
    super.initState();

    _amountTextController.value =
        TextEditingValue(text: _currencyTextInputFormatter.formatDouble(15.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isAdd()
            ? const Text("Add paid membership fee")
            : const Text("Edit paid membership fee"),
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
                            context
                                .read<PaidMembershipFeeCubit>()
                                .deletePaidMembershipFee(
                                  paidMembershipFeeModel:
                                      widget.paidMembershipFeeModel!,
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
        child: BlocConsumer<PaidMembershipFeeCubit, PaidMembershipFeeState>(
          listener: (context, state) {
            if (state is PaidMembershipFeeLoading) {
              CustomCircularLoader.show(context);
            } else if (state is PaidMembershipFeeSuccess) {
              CustomCircularLoader.cancel(context);
              CustomSnackbar.showSuccess(
                context,
                "Success",
              );
              Navigator.pop(context);
            } else if (state is PaidMembershipFeeError) {
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
              key: _addPaidMembershipFeeFormKey,
              child: ListView(
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  CustomTextFormField(
                    controller: _amountTextController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    obsecureText: false,
                    labelText: "Amount",
                    suffix: null,
                    textInputAction: TextInputAction.next,
                    formatter: _currencyTextInputFormatter,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DateTimeFormField(
                    onChanged: (dateTime) {
                      if (dateTime != null) {
                        setState(() {
                          _paymentDate = dateTime;
                        });
                      }
                    },
                    mode: DateTimeFieldPickerMode.date,
                    decoration: const InputDecoration(
                      labelText: "Payment Date",
                      helperText: "YYYY/MM/DD",
                    ),
                    initialValue: DateTime.now(),
                    lastDate: DateTime.now(),
                    canClear: false,
                    validator: (val) {
                      if (val == null) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Paid for year: "),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Select Year"),
                                content: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: YearPicker(
                                    firstDate:
                                        DateTime(DateTime.now().year - 3),
                                    lastDate: DateTime(DateTime.now().year + 3),
                                    selectedDate: DateTime(_year),
                                    onChanged: (DateTime dateTime) {
                                      setState(() {
                                        _year = dateTime.year;
                                      });

                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        label: Text(_year.toString()),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final paidMembershipFeeModel = PaidMembershipFeeModel(
                        id: _isAdd()
                            ? ID.unique()
                            : widget.paidMembershipFeeModel!.id,
                        amount: _currencyTextInputFormatter.getDouble(),
                        year: _year,
                        paymentDate: _paymentDate,
                        memberId: widget.memberId,
                      );
                      if (_isAdd()) {
                        context
                            .read<PaidMembershipFeeCubit>()
                            .addPaidMembershipFee(
                              paidMembershipFeeModel: paidMembershipFeeModel,
                            );
                      } else {
                        context
                            .read<PaidMembershipFeeCubit>()
                            .editPaidMembershipFee(
                              paidMembershipFeeModel: paidMembershipFeeModel,
                            );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Submit"),
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
