import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../errors/exceptions.dart';

class LocationHelper {
  /// Kullanıcının mevcut konumunu al
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(message: 'Konum servisi kapalı. Lütfen açın.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException(message: 'Konum izni reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        message: 'Konum izni kalıcı olarak reddedildi. Ayarlardan izin verin.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  /// Google Maps ile rota oluştur
  static Future<void> openDirections({
    required double destLat,
    required double destLng,
    String? destName,
    double? originLat,
    double? originLng,
  }) async {
    String url;

    if (originLat != null && originLng != null) {
      url = 'https://www.google.com/maps/dir/?api=1'
          '&origin=$originLat,$originLng'
          '&destination=$destLat,$destLng'
          '&travelmode=transit';
    } else {
      url = 'https://www.google.com/maps/dir/?api=1'
          '&destination=$destLat,$destLng'
          '&travelmode=transit';
    }

    if (destName != null) {
      url += '&destination_place_id=$destName';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw const LocationException(message: 'Harita uygulaması açılamadı.');
    }
  }

  /// İki nokta arasındaki mesafeyi hesapla (km)
  static double calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;
  }

  /// Google Maps ile konum aç
  static Future<void> openInMaps(double lat, double lng, {String? label}) async {
    final query = label != null ? Uri.encodeComponent(label) : '$lat,$lng';
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query&center=$lat,$lng');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}