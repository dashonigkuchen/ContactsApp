import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final locator = GetIt.I;

void setupLocator()
{
  locator.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker(),);
}
