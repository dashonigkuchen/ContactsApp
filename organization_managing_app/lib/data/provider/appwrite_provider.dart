import 'package:appwrite/appwrite.dart';
import 'package:organization_managing_app/core/utils/appwrite_constants.dart';

class AppwriteProvider {
  Client client = Client();
  Account? account;
  Databases? database;

  AppwriteProvider() {
    client
        .setEndpoint(AppwriteConstants.endpoint)
        .setProject(AppwriteConstants.projectId)
        .setSelfSigned(status: true);
    account = Account(client);
    database = Databases(client);
  }
}
