import 'package:get_it/get_it.dart';
import 'package:todo_app/core/utils/internet_connection_service.dart';
import 'package:todo_app/core/utils/secure_storage_service.dart';
import 'package:todo_app/data/provider/appwrite_provider.dart';
import 'package:todo_app/data/provider/repository/auth_repository.dart';
import 'package:todo_app/data/provider/repository/todo_repository.dart';

final locator = GetIt.I;

void setupLocator()
{
  locator.registerLazySingleton<InternetConnectionService>(
   () => InternetConnectionService(),
  );

  locator.registerLazySingleton<AppwriteProvider>(
    () => AppwriteProvider(),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(),
  );

  locator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  locator.registerLazySingleton<TodoRepository>(
    () => TodoRepository(),
  );
}
