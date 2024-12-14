import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/core/widgets/custom_snackbar.dart';
import 'package:organization_managing_app/core/widgets/custom_text_form_field.dart';
import 'package:organization_managing_app/data/model/paid_membership_fee_model.dart';
import 'package:organization_managing_app/features/paid_membership_fee/cubit/paid_membership_fee_cubit.dart';

class AddPaidMembershipFeePage extends StatefulWidget {
  final String id;
  const AddPaidMembershipFeePage({
    super.key,
    required this.id,
  });

  @override
  State<AddPaidMembershipFeePage> createState() =>
      _AddPaidMembershipFeePageState();
}

class _AddPaidMembershipFeePageState extends State<AddPaidMembershipFeePage> {
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
        title: const Text("Add paid membership fee"),
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
              context.pop();
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
                                    lastDate:
                                        DateTime(DateTime.now().year + 3),
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
                        icon: const Icon(Icons.save),
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
                        id: widget.id,
                        amount: _currencyTextInputFormatter.getDouble(),
                        year: _year,
                        paymentDate: _paymentDate,
                      );
                      context
                          .read<PaidMembershipFeeCubit>()
                          .addPaidMembershipFee(
                            paidMembershipFeeModel: paidMembershipFeeModel,
                          );
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
