import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/core/error/server_exception.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/core/utils/appwrite_constants.dart';
import 'package:todo_app/core/utils/internet_connection_service.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/data/provider/appwrite_provider.dart';

abstract interface class ITodoRepository {
  Future<Either<Failure, Document>> addTodo({
    required String userId,
    required String title,
    required String description,
    required bool isCompleted,
  });

  Future<Either<Failure, List<TodoModel>>> getTodo({
    required String userId,
  });

  Future<Either<Failure, Document>> editTodo({
    required String documentId,
    required String title,
    required String description,
    required bool isCompleted,
  });

  Future<Either<Failure, dynamic>> deleteTodo({
    required String documentId,
  });
}

class TodoRepository implements ITodoRepository {
  final AppwriteProvider _appwriteProvider = locator<AppwriteProvider>();
  final InternetConnectionService _internetConnectionService = locator<InternetConnectionService>();

  @override
  Future<Either<Failure, Document>> addTodo({
    required String userId,
    required String title,
    required String description,
    required bool isCompleted,
  }) async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        String documentId = ID.unique();
        Document document = await _appwriteProvider.database!.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.todoCollectionId,
          documentId: documentId,
          data: {
            "userId": userId,
            "title": title,
            "description": description,
            "isCompleted": isCompleted,
            "id": documentId,
          },
        );
        return right(document);
      } else {
       return left(Failure(
          message: "",
          type: FailureType.internet,
        ));
      }
    } on AppwriteException catch (e) {
      return left(Failure(
        message: e.message!,
        type: FailureType.appwrite,
      ));
    } on ServerException catch (e) {
      return left(Failure(
        message: e.message,
        type: FailureType.internal,
      ));
    }
  }

  @override
  Future<Either<Failure, List<TodoModel>>> getTodo({
    required String userId,
  }) async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        DocumentList list = await _appwriteProvider.database!.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.todoCollectionId,
          queries: [
            Query.equal("userId", userId),
          ],
        );
        Map<String, dynamic> data = list.toMap();
        List d = data['documents'].toList();
        List<TodoModel> todoList =
            d.map((e) => TodoModel.fromMap(e['data'])).toList();
        return right(todoList);
      } else {
       return left(Failure(
          message: "",
          type: FailureType.internet,
        ));
      }
    } on AppwriteException catch (e) {
      return left(Failure(
        message: e.message!,
        type: FailureType.appwrite,
      ));
    } on ServerException catch (e) {
      return left(Failure(
        message: e.message,
        type: FailureType.internal,
      ));
    }
  }

  @override
  Future<Either<Failure, Document>> editTodo({
    required String documentId,
    required String title,
    required String description,
    required bool isCompleted,
  }) async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        Document document = await _appwriteProvider.database!.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.todoCollectionId,
          documentId: documentId,
          data: {
            "title": title,
            "description": description,
            "isCompleted": isCompleted,
          },
        );
        return right(document);
      } else {
       return left(Failure(
          message: "",
          type: FailureType.internet,
        ));
      }
    } on AppwriteException catch (e) {
      return left(Failure(
        message: e.message!,
        type: FailureType.appwrite,
      ));
    } on ServerException catch (e) {
      return left(Failure(
        message: e.message,
        type: FailureType.internal,
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteTodo({
    required String documentId,
  }) async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        var response = await _appwriteProvider.database!.deleteDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.todoCollectionId,
          documentId: documentId,
        );
        
        return right(response);
      } else {
       return left(Failure(
          message: "",
          type: FailureType.internet,
        ));
      }
    } on AppwriteException catch (e) {
      return left(Failure(
        message: e.message!,
        type: FailureType.appwrite,
      ));
    } on ServerException catch (e) {
      return left(Failure(
        message: e.message,
        type: FailureType.internal,
      ));
    }
  }
}
