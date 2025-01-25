// ignore_for_file: public_member_api_docs, sort_constructors_first

class CacheException implements Exception {
  final String message;

  CacheException({
    required this.message,
  });

  // factory CacheException.fromMap(Map<String, dynamic> map) =>
  //     CacheException(message: map['error']);
}
