class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() {
    return 'ServerException: ${statusCode != null ? "[$statusCode] " : ""}$message';
  }
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() {
    return 'CacheException: $message';
  }
}
