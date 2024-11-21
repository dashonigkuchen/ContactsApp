import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/core/error/server_exception.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/core/utils/appwrite_constants.dart';
import 'package:todo_app/core/utils/internet_connection_service.dart';
import 'package:todo_app/data/provider/appwrite_provider.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, Session>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Session>> checkSession();

  Future<Failure?> logout();
}

class AuthRepository implements IAuthRepository {
  final AppwriteProvider _appwriteProvider = locator<AppwriteProvider>();
  final InternetConnectionService _internetConnectionService =
      locator<InternetConnectionService>();

  @override
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        User user = await _appwriteProvider.account!.create(
            userId: ID.unique(),
            email: email,
            password: password,
            name: "$firstName $lastName");
        await _appwriteProvider.database!.createDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.userCollectionId,
            documentId: user.$id,
            data: {
              "id": user.$id,
              "first_name": firstName,
              "last_name": lastName,
              "full_name": "$firstName $lastName",
              "email": email,
            });

        return right(user);
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
  Future<Either<Failure, Session>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        Session session =
            await _appwriteProvider.account!.createEmailPasswordSession(
          email: email,
          password: password,
        );

        return right(session);
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
  Future<Either<Failure, Session>> checkSession() async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        Session session = await _appwriteProvider.account!.getSession(
          sessionId: "current",
        );

        return right(session);
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
  Future<Failure?> logout() async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        await _appwriteProvider.account!.deleteSession(
          sessionId: "current",
        );
        return null;
      } else {
        return Failure(
          message: "",
          type: FailureType.internet,
        );
      }
    } on AppwriteException catch (e) {
      return Failure(
        message: e.message!,
        type: FailureType.appwrite,
      );
    } on ServerException catch (e) {
      return Failure(
        message: e.message,
        type: FailureType.internal,
      );
    }
  }
}
