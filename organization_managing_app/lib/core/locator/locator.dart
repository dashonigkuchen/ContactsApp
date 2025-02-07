import 'package:get_it/get_it.dart';
import 'package:organization_managing_app/data/provider/appwrite_provider.dart';
import 'package:organization_managing_app/data/provider/repository/auth_repository.dart';
import 'package:organization_managing_app/core/internet/internet_connection_service.dart';
import 'package:organization_managing_app/core/storage/secure_storage_service.dart';
import 'package:organization_managing_app/data/provider/repository/members_repository.dart';
import 'package:organization_managing_app/data/provider/repository/paid_membership_fee_repository.dart';
import 'package:organization_managing_app/features/common/common_data_loader.dart';
import 'package:organization_managing_app/features/members/members_filter_container.dart';

final locator = GetIt.I;

void setupLocator() {
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

  locator.registerLazySingleton<MembersFilterContainer>(
    () => MembersFilterContainer(
      secureStorageService: locator.get<SecureStorageService>(),
    ),
  );

  locator.registerLazySingleton<CommonDataLoader>(
    () => CommonDataLoader(),
  );
}
