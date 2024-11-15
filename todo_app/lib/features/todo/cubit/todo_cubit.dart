import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/core/utils/secure_storage_service.dart';
import 'package:todo_app/core/utils/storage_key.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/data/provider/repository/todo_repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _todoRepository = locator<TodoRepository>();
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();

  TodoCubit() : super(TodoInitial());

  void addTodo({
    required String title,
    required String description,
    required bool isCompleted,
  }) async {
    emit(TodoAddEditDeleteLoading());

    String userId = await _secureStorageService.getValue(
      StorageKey.userId,
    ) ?? "";

    final res = await _todoRepository.addTodo(
      userId: userId,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );

    res.fold((failure) => emit(TodoError(error: failure.message)),
        (document) => emit(TodoAddEditDeleteSuccess()));
  }

  void getTodo() async {
    emit(TodoFetchLoading());

    String userId = await _secureStorageService.getValue(
      StorageKey.userId,
    ) ?? "";

    final res = await _todoRepository.getTodo(
      userId: userId,
    );

    res.fold((failure) => emit(TodoError(error: failure.message)),
        (todoModel) => emit(TodoFetchSuccess(todoModel: todoModel)));
  }

  void editTodo({
    required String documentId,
    required String title,
    required String description,
    required bool isCompleted,
  }) async {
    emit(TodoAddEditDeleteLoading());

    final res = await _todoRepository.editTodo(
      documentId: documentId,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );

    res.fold((failure) => emit(TodoError(error: failure.message)),
        (document) => emit(TodoAddEditDeleteSuccess()));
  }

  void deleteTodo({
    required String documentId,
  }) async {
    emit(TodoAddEditDeleteLoading());

    final res = await _todoRepository.deleteTodo(
      documentId: documentId,
    );

    res.fold((failure) => emit(TodoError(error: failure.message)),
        (_) => emit(TodoAddEditDeleteSuccess()));
  }
}
