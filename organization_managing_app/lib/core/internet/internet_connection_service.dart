import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionService {
  final InternetConnection _internetConnection = InternetConnection();

  Future<bool> hasInternetAccess() async {
    return await _internetConnection.hasInternetAccess;
  }
}