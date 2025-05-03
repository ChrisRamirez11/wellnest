// ignore_for_file: public_member_api_docs, sort_constructors_first

class CacheException implements Exception {
  final String message;

  CacheException({
    required this.message,
  });

  @override
  String toString() {
    Object? message = this.message;
    return "Cache Error: $message";
  }
}

class ServerException implements Exception {
  final String message;
  ServerException({
    required this.message,
  });

  @override
  String toString() {
    Object? message = this.message;
    return "$message";
  }
}
