import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/service_remote_datasource.dart';
import '../../domain/entities/service_entity.dart';

// Datasource provider
final serviceRemoteDataSourceProvider = Provider<ServiceRemoteDataSource>((ref) {
  return ServiceRemoteDataSourceImpl(Supabase.instance.client);
});

// State
class ServiceMapState {
  final List<ServiceEntity> services;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;
  final int radiusKm;
  final double? userLat;
  final double? userLng;

  const ServiceMapState({
    this.services = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.radiusKm = 10,
    this.userLat,
    this.userLng,
  });

  ServiceMapState copyWith({
    List<ServiceEntity>? services,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    int? radiusKm,
    double? userLat,
    double? userLng,
  }) {
    return ServiceMapState(
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      radiusKm: radiusKm ?? this.radiusKm,
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
    );
  }
}

class ServiceMapNotifier extends StateNotifier<ServiceMapState> {
  final ServiceRemoteDataSource _dataSource;

  ServiceMapNotifier(this._dataSource) : super(const ServiceMapState());

  Future<void> loadNearbyServices({
    required double lat,
    required double lng,
    int? radiusKm,
    String? category,
  }) async {
    state = state.copyWith(
      isLoading: true,
      userLat: lat,
      userLng: lng,
    );

    try {
      final services = await _dataSource.getNearbyServices(
        lat: lat,
        lng: lng,
        radiusKm: radiusKm ?? state.radiusKm,
        categoryFilter: category ?? state.selectedCategory,
      );
      state = state.copyWith(services: services, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> searchServices(String query) async {
    state = state.copyWith(isLoading: true);

    try {
      final services = await _dataSource.searchServices(query);
      state = state.copyWith(services: services, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    if (state.userLat != null && state.userLng != null) {
      loadNearbyServices(lat: state.userLat!, lng: state.userLng!, category: category);
    }
  }

  void setRadius(int radiusKm) {
    state = state.copyWith(radiusKm: radiusKm);
    if (state.userLat != null && state.userLng != null) {
      loadNearbyServices(lat: state.userLat!, lng: state.userLng!, radiusKm: radiusKm);
    }
  }
}

// Provider
final serviceMapProvider = StateNotifierProvider<ServiceMapNotifier, ServiceMapState>((ref) {
  final dataSource = ref.watch(serviceRemoteDataSourceProvider);
  return ServiceMapNotifier(dataSource);
});

// Service detail provider
final serviceDetailProvider = FutureProvider.family<ServiceEntity, String>((ref, id) async {
  final dataSource = ref.watch(serviceRemoteDataSourceProvider);
  return dataSource.getServiceById(id);
});