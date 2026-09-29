import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getNearbyServices({
    required double lat,
    required double lng,
    int radiusKm = 10,
    String? categoryFilter,
    String? langFilter,
  });

  Future<List<ServiceModel>> searchServices(String query);

  Future<ServiceModel> getServiceById(String id);

  Future<List<ServiceModel>> getServicesByCategory(String category);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final SupabaseClient _client;

  ServiceRemoteDataSourceImpl(this._client);

  @override
  Future<List<ServiceModel>> getNearbyServices({
    required double lat,
    required double lng,
    int radiusKm = 10,
    String? categoryFilter,
    String? langFilter,
  }) async {
    try {
      final response = await _client.rpc('nearby_services', params: {
        'lat': lat,
        'lng': lng,
        'radius_km': radiusKm,
        'category_filter': categoryFilter,
        'lang_filter': langFilter,
      });

      final data = response as List;
      return data.map((json) => ServiceModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException(message: 'Hizmetler yüklenirken hata oluştu: $e');
    }
  }

  @override
  Future<List<ServiceModel>> searchServices(String query) async {
    try {
      final response = await _client
          .from('services')
          .select()
          .eq('is_active', true)
          .or('name->>tr.ilike.%$query%,name->>en.ilike.%$query%,name->>ar.ilike.%$query%')
          .limit(20);

      return (response as List)
          .map((json) => ServiceModel.fromSupabaseRow(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Arama sırasında hata oluştu: $e');
    }
  }

  @override
  Future<ServiceModel> getServiceById(String id) async {
    try {
      final response = await _client
          .from('services')
          .select()
          .eq('id', id)
          .single();

      return ServiceModel.fromSupabaseRow(response);
    } catch (e) {
      throw ServerException(message: 'Hizmet detayı yüklenemedi: $e');
    }
  }

  @override
  Future<List<ServiceModel>> getServicesByCategory(String category) async {
    try {
      final response = await _client
          .from('services')
          .select()
          .eq('is_active', true)
          .eq('category', category)
          .limit(50);

      return (response as List)
          .map((json) => ServiceModel.fromSupabaseRow(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Kategori hizmetleri yüklenemedi: $e');
    }
  }
}