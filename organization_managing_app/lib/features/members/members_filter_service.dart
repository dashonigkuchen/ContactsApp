import 'package:appwrite/appwrite.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/core/storage/secure_storage_service.dart';
import 'package:organization_managing_app/core/storage/storage_key.dart';

class MembersFilterService {
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();

  late MembersFilterContainer membersFilterContainer;

  Future<void> init() async {
    bool onlyHonoraryMember = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyHonoraryMembers)) ??
        "false");
    bool onlyNotPaidMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyNotPaidMembers)) ??
        "false");
    bool onlyPaidMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyPaidMembers)) ??
        "false");
    bool onlyNoPaymentNeededMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyNoPaymentNeededMembers)) ??
        "false");
    bool onlyBoardMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyBoardMembers)) ??
        "false");
    bool alsoShowDeactivatedMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterAlsoShowDeactivatedMembers)) ??
        "false");
    bool onlyDeactivatedMembers = bool.parse((await _secureStorageService
            .getValue(StorageKey.filterOnlyDeactivatedMembers)) ??
        "false");

    membersFilterContainer = MembersFilterContainer(
      onlyHonoraryMember: onlyHonoraryMember,
      onlyNotPaidMembers: onlyNotPaidMembers,
      onlyPaidMembers: onlyPaidMembers,
      onlyNoPaymentNeededMembers: onlyNoPaymentNeededMembers,
      onlyBoardMembers: onlyBoardMembers,
      alsoShowDeactivatedMembers: alsoShowDeactivatedMembers,
      onlyDeactivatedMembers: onlyDeactivatedMembers,
    );
  }

  List<String>? generateQueries() {
    List<String> queries = <String>[];
    if (membersFilterContainer.onlyHonoraryMember) {
      queries.add(Query.equal(
          "isHonoraryMember", membersFilterContainer.onlyHonoraryMember));
    }
    if (membersFilterContainer.onlyNotPaidMembers) {
      // usage of appwrite relationship + query would be nice, but not possible as of now
    }
    if (membersFilterContainer.onlyPaidMembers) {
      // usage of appwrite relationship + query would be nice, but not possible as of now
    }
    if (membersFilterContainer.onlyNoPaymentNeededMembers) {
      queries.add(Query.or([
        Query.equal("isHonoraryMember", true),
        Query.isNotNull("noMembershipFeeNeededReason"),
      ]));
    }
    if (membersFilterContainer.onlyBoardMembers) {
      queries.add(Query.isNotNull("boardFunction"));
    }
    if (!membersFilterContainer.alsoShowDeactivatedMembers &&
        !membersFilterContainer.onlyDeactivatedMembers) {
      queries.add(Query.equal("active", true));
    }
    if (membersFilterContainer.onlyDeactivatedMembers) {
      queries.add(Query.equal("active", false));
    }

    if (queries.isNotEmpty) {
      return queries;
    }

    return null;
  }

  void storeCurrentFilter() {
    _secureStorageService.setValue(StorageKey.filterOnlyHonoraryMembers,
        membersFilterContainer.onlyHonoraryMember.toString());
    _secureStorageService.setValue(StorageKey.filterOnlyNotPaidMembers,
        membersFilterContainer.onlyNotPaidMembers.toString());
    _secureStorageService.setValue(StorageKey.filterOnlyPaidMembers,
        membersFilterContainer.onlyPaidMembers.toString());
    _secureStorageService.setValue(StorageKey.filterOnlyNoPaymentNeededMembers,
        membersFilterContainer.onlyNoPaymentNeededMembers.toString());
    _secureStorageService.setValue(StorageKey.filterOnlyBoardMembers,
        membersFilterContainer.onlyBoardMembers.toString());
    _secureStorageService.setValue(StorageKey.filterAlsoShowDeactivatedMembers,
        membersFilterContainer.alsoShowDeactivatedMembers.toString());
    _secureStorageService.setValue(StorageKey.filterOnlyDeactivatedMembers,
        membersFilterContainer.onlyDeactivatedMembers.toString());
  }
}

class MembersFilterContainer {
  bool onlyHonoraryMember = false;
  bool onlyNotPaidMembers = false;
  bool onlyPaidMembers = false;
  bool onlyNoPaymentNeededMembers = false;
  bool onlyBoardMembers = false;
  bool alsoShowDeactivatedMembers = false;
  bool onlyDeactivatedMembers = false;

  MembersFilterContainer({
    required this.onlyHonoraryMember,
    required this.onlyNotPaidMembers,
    required this.onlyPaidMembers,
    required this.onlyNoPaymentNeededMembers,
    required this.onlyBoardMembers,
    required this.alsoShowDeactivatedMembers,
    required this.onlyDeactivatedMembers,
  });

  MembersFilterContainer copy() => MembersFilterContainer(
        onlyHonoraryMember: onlyHonoraryMember,
        onlyNotPaidMembers: onlyNotPaidMembers,
        onlyPaidMembers: onlyPaidMembers,
        onlyNoPaymentNeededMembers: onlyNoPaymentNeededMembers,
        onlyBoardMembers: onlyBoardMembers,
        alsoShowDeactivatedMembers: alsoShowDeactivatedMembers,
        onlyDeactivatedMembers: onlyDeactivatedMembers,
      );
}
