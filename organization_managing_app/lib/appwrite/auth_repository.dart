import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:organization_managing_app/appwrite/appwrite_provider.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/error/server_exception.dart';
import 'package:organization_managing_app/core/internet/internet_connection_service.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/core/utils/appwrite_constants.dart';

class AuthRepository {
  final AppwriteProvider _appwriteProvider = locator<AppwriteProvider>();
  final InternetConnectionService _internetConnectionService =
      locator<InternetConnectionService>();

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
              "name": firstName,
              "email": email,
            });

        return right(user);
      } else {
        return left(Failure(
          message: "", // Message will be translated
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

  Future<Either<Failure, Session>> signInWithEmail({
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
          message: "", // Message will be translated
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

  Future<Either<Failure, Session>> signInWithProvider({
    required OAuthProvider provider,
  }) async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        Session session = await _appwriteProvider.account!.createOAuth2Session(
          provider: provider,
        );

        return right(session);
      } else {
        return left(Failure(
          message: "", // Message will be translated
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

  Future<Either<Failure, Session>> checkSession() async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        Session session = await _appwriteProvider.account!.getSession(
          sessionId: "current",
        );

        return right(session);
      } else {
        return left(Failure(
          message: "", // Message will be translated
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

  Future<Failure?> signOut() async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        await _appwriteProvider.account!.deleteSession(
          sessionId: "current",
        );
        return null;
      } else {
        return Failure(
          message: "", // Message will be translated
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
