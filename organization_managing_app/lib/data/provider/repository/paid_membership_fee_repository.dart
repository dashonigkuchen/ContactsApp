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
          documentId: paidMembershipFeeModel.id,
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

  Future<Either<Failure, List<PaidMembershipFeeModel>>>
      getAllPaidMembershipFees() async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        DocumentList documents =
            await _appwriteProvider.database!.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.paidMembershipFeeCollectionId,
        );
        Map<String, dynamic> data = documents.toMap();
        List d = data['documents'].toList();
        List<PaidMembershipFeeModel> paidMemberShipFeeList =
            d.map((e) => PaidMembershipFeeModel.fromMap(e['data'])).toList();
        return right(paidMemberShipFeeList);
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

  Future<Either<Failure, dynamic>> deletePaidMembershipFeesOfMember({
    required String memberId,
  }) async {
    try {
      if (await _internetConnectionService.hasInternetAccess()) {
        final res = await getAllPaidMembershipFees();
        if (res.isLeft()) {
          return left(res.getLeft().toNullable()!);
        } else {
          dynamic response;
          for (final paidMembershipFee in res.getRight().toNullable()!) {
            if (paidMembershipFee.memberId == memberId) {
              response = await _appwriteProvider.database!.deleteDocument(
                databaseId: AppwriteConstants.databaseId,
                collectionId: AppwriteConstants.paidMembershipFeeCollectionId,
                documentId: paidMembershipFee.id,
              );
            }
          }
          return right(response);
        }
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
