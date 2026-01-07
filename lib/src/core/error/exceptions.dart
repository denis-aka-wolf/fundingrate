/// Represents exceptions that occur during data fetching or processing.
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

/// Exception thrown when a network request fails.
class ServerException extends AppException {
  ServerException({String message = 'A server error occurred.'}) : super(message);
}

/// Exception thrown when there is no internet connection.
class NetworkException extends AppException {
  NetworkException({String message = 'No internet connection.'}) : super(message);
}

/// Exception thrown when parsing data fails.
class CacheException extends AppException {
  CacheException({String message = 'A cache error occurred.'}) : super(message);
}