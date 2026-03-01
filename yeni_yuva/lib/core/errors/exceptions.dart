class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'İnternet bağlantısı bulunamadı.'});
}

class AppAuthException implements Exception {
  final String message;

  const AppAuthException({required this.message});
}

class LocationException implements Exception {
  final String message;

  const LocationException({required this.message});
}