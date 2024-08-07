class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class LocalStorageException implements Exception {
  final String message;

  LocalStorageException({required this.message});
}

class NoInternetException implements Exception {
  final String message;

  NoInternetException(this.message);
}

// class DatabaseException implements Exception {
//   final String message;

//   DatabaseException(this.message);
// }

// class CacheException implements Exception {
//   final String message;

//   CacheException(this.message);
// }

// class UnauthorizedException implements Exception {
//   final String message;

//   UnauthorizedException(this.message);
// }

// class NotFoundException implements Exception {
//   final String message;

//   NotFoundException(this.message);
// }

// class BadRequestException implements Exception {
//   final String message;

//   BadRequestException(this.message);
// }