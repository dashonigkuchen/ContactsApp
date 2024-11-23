import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void setValue(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> getValue(String key) async {
    return await _storage.read(
      key: key,
      aOptions: _getAndroidOptions(),
    );
  }

  void clearAll() async {
    await _storage.deleteAll(
      aOptions: _getAndroidOptions(),
    );
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}