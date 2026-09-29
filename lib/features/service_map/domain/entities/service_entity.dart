class ServiceEntity {
  final String id;
  final Map<String, String> name;
  final Map<String, String>? description;
  final String category;
  final Map<String, String> address;
  final String? phone;
  final Map<String, dynamic>? workingHours;
  final List<String> spokenLanguages;
  final String? website;
  final double latitude;
  final double longitude;
  final double? distanceKm;

  const ServiceEntity({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.address,
    this.phone,
    this.workingHours,
    this.spokenLanguages = const ['tr'],
    this.website,
    required this.latitude,
    required this.longitude,
    this.distanceKm,
  });

  String getLocalizedName(String lang) => name[lang] ?? name['tr'] ?? '';
  String getLocalizedDescription(String lang) => description?[lang] ?? description?['tr'] ?? '';
  String getLocalizedAddress(String lang) => address[lang] ?? address['tr'] ?? '';
}