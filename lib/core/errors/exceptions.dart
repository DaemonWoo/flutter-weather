class ServerException implements Exception {
  const ServerException([this.message = 'An error has occurred']);

  final String message;
}

class EmptyQueryException implements Exception {
  const EmptyQueryException();
}

class MissingApiKeyException implements Exception {
  const MissingApiKeyException();
}
