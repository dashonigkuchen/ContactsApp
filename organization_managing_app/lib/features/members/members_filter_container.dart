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
  late bool alsoShowDeactivatedMembers = false;
  late bool onlyDeactivatedMembers = false;

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
    alsoShowDeactivatedMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterAlsoShowDeactivatedMembers)) ??
        "false");
    onlyDeactivatedMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyDeactivatedMembers)) ??
        "false");
  }

  List<String>? generateQueries() {
    List<String> queries = <String>[];
    if (onlyHonoraryMember) {
      queries.add(Query.equal("isHonoraryMember", onlyHonoraryMember));
    }
    if (onlyNotPaidMembers) {
      // usage of appwrite relationship + query would be nice, but not possible as of now
    }
    if (onlyPaidMembers) {
      // usage of appwrite relationship + query would be nice, but not possible as of now
    }
    if (onlyNoPaymentNeededMembers) {
      queries.add(Query.or([
        Query.equal("isHonoraryMember", true),
        Query.isNotNull("noMembershipFeeNeededReason"),
      ]));
    }
    if (onlyBoardMembers) {
      queries.add(Query.isNotNull("boardFunction"));
    }
    if (!alsoShowDeactivatedMembers && !onlyDeactivatedMembers) {
      queries.add(Query.equal("active", true));
    }
    if (onlyDeactivatedMembers) {
      queries.add(Query.equal("active", false));
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
    _secureStorageService.setValue(
        StorageKey.filterAlsoShowDeactivatedMembers, alsoShowDeactivatedMembers.toString());
    _secureStorageService.setValue(
        StorageKey.filterOnlyDeactivatedMembers, onlyDeactivatedMembers.toString());
  }
}
