import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/core/language/translation.dart';
import 'package:todo_app/core/theme/app_color.dart';
import 'package:todo_app/core/utils/custom_snackbar.dart';
import 'package:todo_app/core/utils/full_screen_dialog_loader.dart';
import 'package:todo_app/core/widgets/custom_text_form_field.dart';
import 'package:todo_app/core/widgets/rounded_elevated_button.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/features/todo/cubit/todo_cubit.dart';

class AddEditTodoView extends StatefulWidget {
  final TodoModel? todoModel;
  const AddEditTodoView({
    super.key,
    this.todoModel,
  });

  @override
  State<AddEditTodoView> createState() => _AddEditTodoViewState();
}

class _AddEditTodoViewState extends State<AddEditTodoView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleEditingController,
      _descriptionEditingController;
  late bool isCompleted;

  @override
  void initState() {
    super.initState();

    _titleEditingController = TextEditingController(
      text: widget.todoModel?.title ?? '',
    );
    _descriptionEditingController = TextEditingController(
      text: widget.todoModel?.description ?? '',
    );
    isCompleted = widget.todoModel?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    super.dispose();
  }

  clearText() {
    _titleEditingController.clear();
    _descriptionEditingController.clear();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleEditingController.text;
      final description = _descriptionEditingController.text;

      if (widget.todoModel == null) {
        context.read<TodoCubit>().addTodo(
              title: title,
              description: description,
              isCompleted: false,
            );
      } else {
        context.read<TodoCubit>().editTodo(
              documentId: widget.todoModel!.id,
              title: title,
              description: description,
              isCompleted: isCompleted,
            );
      }
    }
  }

  void _deleteTodo({
    required String documentId,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: translator(context).titleDeleteTodo,
      desc: translator(context).askDeleteTodo,
      dismissOnTouchOutside: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        context.read<TodoCubit>().deleteTodo(
              documentId: documentId,
            );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todoModel == null
            ? translator(context).titleAddTodo
            : translator(context).titleEditTodo),
        actions: [
          if (widget.todoModel != null)
            IconButton(
              onPressed: () {
                _deleteTodo(
                  documentId: widget.todoModel!.id,
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
        child: BlocConsumer<TodoCubit, TodoState>(
          listener: (context, state) {
            if (state is TodoAddEditDeleteLoading) {
              FullScreenDialogLoader.show(context);
            } else if (state is TodoAddEditDeleteSuccess) {
              clearText();
              FullScreenDialogLoader.cancel(context);
              CustomSnackbar.showSuccess(
                context,
                translator(context).infoSuccess,
              );
              context.pop();
              context.read<TodoCubit>().getTodo();
            } else if (state is TodoError) {
              FullScreenDialogLoader.cancel(context);
              CustomSnackbar.showError(
                context,
                Failure.createFailureString(
                  context: context,
                  failure: state.failure,
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _titleEditingController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return translator(context).errorFieldRequired;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obsecureText: false,
                    hintText: translator(context).hintTodoTitle,
                    suffix: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _descriptionEditingController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return translator(context).errorFieldRequired;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obsecureText: false,
                    hintText: translator(context).hintTodoDescription,
                    suffix: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (widget.todoModel != null)
                    Checkbox(
                      value: isCompleted,
                      onChanged: (value) {
                        setState(() {
                          isCompleted = value!;
                        });
                      },
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedElevatedButton(
                    buttonText: widget.todoModel == null
                        ? translator(context).buttonAddTodo
                        : translator(context).buttonEditTodo,
                    onPressed: () {
                      _submit();
                    },
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
