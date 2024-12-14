import 'package:get_it/get_it.dart';
import 'package:organization_managing_app/data/provider/appwrite_provider.dart';
import 'package:organization_managing_app/data/provider/repository/auth_repository.dart';
import 'package:organization_managing_app/core/internet/internet_connection_service.dart';
import 'package:organization_managing_app/core/storage/secure_storage_service.dart';
import 'package:organization_managing_app/data/provider/repository/members_repository.dart';
import 'package:organization_managing_app/data/provider/repository/paid_membership_fee_repository.dart';

final locator = GetIt.I;

void setupLocator()
{
  locator.registerLazySingleton<InternetConnectionService>(
   () => InternetConnectionService(),
  );

  locator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  locator.registerLazySingleton<AppwriteProvider>(
    () => AppwriteProvider(),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(),
  );

  locator.registerLazySingleton<MembersRepository>(
    () => MembersRepository(),
  );

  locator.registerLazySingleton<PaidMembershipFeeRepository>(
    () => PaidMembershipFeeRepository(),
  );
}