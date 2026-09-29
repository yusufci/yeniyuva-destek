import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    super.description,
    required super.category,
    required super.address,
    super.phone,
    super.workingHours,
    super.spokenLanguages,
    super.website,
    required super.latitude,
    required super.longitude,
    super.distanceKm,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: _parseJsonbToMap(json['name']),
      description: json['description'] != null ? _parseJsonbToMap(json['description']) : null,
      category: json['category'] as String,
      address: _parseJsonbToMap(json['address']),
      phone: json['phone'] as String?,
      workingHours: json['working_hours'] as Map<String, dynamic>?,
      spokenLanguages: json['spoken_languages'] != null
          ? List<String>.from(json['spoken_languages'] as List)
          : const ['tr'],
      website: json['website'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
    );
  }

  factory ServiceModel.fromSupabaseRow(Map<String, dynamic> json) {
    // Supabase doğrudan sorgudan gelen format (PostGIS location ayrıştır)
    double lat = 0.0;
    double lng = 0.0;

    if (json['location'] != null) {
      // PostGIS POINT format gelirse
      final location = json['location'];
      if (location is Map) {
        lat = (location['coordinates']?[1] as num?)?.toDouble() ?? 0.0;
        lng = (location['coordinates']?[0] as num?)?.toDouble() ?? 0.0;
      }
    }

    return ServiceModel(
      id: json['id'] as String,
      name: _parseJsonbToMap(json['name']),
      description: json['description'] != null ? _parseJsonbToMap(json['description']) : null,
      category: json['category'] as String,
      address: _parseJsonbToMap(json['address']),
      phone: json['phone'] as String?,
      workingHours: json['working_hours'] as Map<String, dynamic>?,
      spokenLanguages: json['spoken_languages'] != null
          ? List<String>.from(json['spoken_languages'] as List)
          : const ['tr'],
      website: json['website'] as String?,
      latitude: lat,
      longitude: lng,
    );
  }

  static Map<String, String> _parseJsonbToMap(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {};
  }
}