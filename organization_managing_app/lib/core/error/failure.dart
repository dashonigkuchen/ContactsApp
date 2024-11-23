enum FailureType {
  appwrite,
  internal,
  internet,
}

class Failure {
  final String message;
  final FailureType type;

  Failure({
    required this.message,
    required this.type,
  });
}