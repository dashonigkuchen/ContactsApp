import 'package:get_it/get_it.dart';
import 'package:organization_managing_app/appwrite/appwrite_provider.dart';
import 'package:organization_managing_app/appwrite/auth_repository.dart';
import 'package:organization_managing_app/core/internet/internet_connection_service.dart';
import 'package:organization_managing_app/core/storage/secure_storage_service.dart';

final locator = GetIt.I;

void setupLocator()
{
  locator.registerLazySingleton<InternetConnectionService>(
   () => InternetConnectionService(),
  );

  locator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(),
  );

  locator.registerLazySingleton<AppwriteProvider>(
    () => AppwriteProvider(),
  );
}