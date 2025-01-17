import 'package:organization_managing_app/core/storage/secure_storage_service.dart';
import 'package:organization_managing_app/core/storage/storage_key.dart';

class MembersFilterContainer {
  late SecureStorageService _secureStorageService;

  late bool _isHonoraryMember = false;

  bool get isHonoraryMember => _isHonoraryMember;

  MembersFilterContainer({
    required SecureStorageService secureStorageService,
  }) {
    _secureStorageService = secureStorageService;
  }

  Future<void> init() async {
    _isHonoraryMember = bool.parse((await _secureStorageService
        .getValue(StorageKey.filterOnlyHonoraryMember))!);
  }

  void storeCurrentFilter() {
    _secureStorageService.setValue(
        StorageKey.filterOnlyHonoraryMember, isHonoraryMember.toString());
  }

  void setIsHonoraryMember(bool isHonoraryMember) {
    _isHonoraryMember = isHonoraryMember;
  }
}
