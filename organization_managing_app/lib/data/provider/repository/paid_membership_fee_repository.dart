import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/error/server_exception.dart';
import 'package:organization_managing_app/core/internet/internet_connection_service.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/core/utils/appwrite_constants.dart';
import 'package:organization_managing_app/data/model/paid_membership_fee_model.dart';
import 'package:organization_managing_app/data/provider/appwrite_provider.dart';

class PaidMembershipFeeRepository {
  final AppwriteProvider _appwriteProvider = locator<AppwriteProvider>();
  final InternetConnectionService _internetConnectionService =
      locator<InternetConnectionService>();

  Future<Either<Failure, Document>> addPaidMembershipFee({
    required PaidMembershipFeeModel paidMembershipFeeModel,
  }) async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        Document document = await _appwriteProvider.database!.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.paidMembershipFeeCollectionId,
          documentId: ID.unique(),
          data: paidMembershipFeeModel.toMap(),
        );
        return right(document);
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
}
