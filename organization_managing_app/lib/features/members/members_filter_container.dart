import 'package:appwrite/appwrite.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/core/storage/secure_storage_service.dart';
import 'package:organization_managing_app/core/storage/storage_key.dart';

class MembersFilterContainer {
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();

  late bool onlyHonoraryMember = false;
  late bool onlyNotPaidMembers = false;
  late bool onlyPaidMembers = false;
  late bool onlyNoPaymentNeededMembers = false;
  late bool onlyBoardMembers = false;

  Future<void> init() async {
    onlyHonoraryMember = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyHonoraryMembers)) ??
        "false");
    onlyNotPaidMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyNotPaidMembers)) ??
        "false");
    onlyPaidMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyPaidMembers)) ??
        "false");
    onlyNoPaymentNeededMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyNoPaymentNeededMembers)) ??
        "false");
    onlyBoardMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyBoardMembers)) ??
        "false");
  }

  List<String>? generateQueries() {
    List<String> queries = <String>[];
    if (onlyHonoraryMember == true) {
      queries.add(Query.equal("isHonoraryMember", onlyHonoraryMember));
    }
    if (onlyNotPaidMembers == true) {
      // usage of appwrite relationship + query would be nice, but not possible as of now
    }
    if (onlyPaidMembers == true) {
      // usage of appwrite relationship + query would be nice, but not possible as of now
    }
    if (onlyNoPaymentNeededMembers == true) {
      queries.add(Query.or([
        Query.equal("isHonoraryMember", true),
        Query.isNotNull("noMembershipFeeNeededReason"),
      ]));
    }
    if (onlyBoardMembers == true) {
      queries.add(Query.isNotNull("boardFunction"));
    }

    if (queries.isNotEmpty) {
      return queries;
    }

    return null;
  }

  void storeCurrentFilter() {
    _secureStorageService.setValue(
        StorageKey.filterOnlyHonoraryMembers, onlyHonoraryMember.toString());
    _secureStorageService.setValue(
        StorageKey.filterOnlyNotPaidMembers, onlyNotPaidMembers.toString());
    _secureStorageService.setValue(
        StorageKey.filterOnlyPaidMembers, onlyPaidMembers.toString());
    _secureStorageService.setValue(StorageKey.filterOnlyNoPaymentNeededMembers,
        onlyNoPaymentNeededMembers.toString());
    _secureStorageService.setValue(
        StorageKey.filterOnlyBoardMembers, onlyBoardMembers.toString());
  }
}
