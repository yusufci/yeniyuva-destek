import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/location_helper.dart';
import '../../domain/entities/service_entity.dart';
import '../providers/service_map_provider.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;
  bool _isLoadingLocation = false;

  // Varsayılan konum: İstanbul
  static const _defaultLat = 41.0082;
  static const _defaultLng = 28.9784;

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında konum al ve hizmetleri yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    try {
      final position = await LocationHelper.getCurrentPosition();
      ref.read(serviceMapProvider.notifier).loadNearbyServices(
        lat: position.latitude,
        lng: position.longitude,
      );
    } catch (_) {
      // Konum alınamazsa varsayılan İstanbul koordinatlarını kullan
      ref.read(serviceMapProvider.notifier).loadNearbyServices(
        lat: _defaultLat,
        lng: _defaultLng,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(serviceMapProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Mapbox Harita
          MapWidget(
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(_defaultLng, _defaultLat)),
              zoom: 13.0,
            ),
            styleUri: MapboxStyles.STANDARD,
            onMapCreated: _onMapCreated,
          ),

          // Üst bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      Expanded(
                        child: TextField(
                          onSubmitted: (query) {
                            if (query.isNotEmpty) {
                              ref.read(serviceMapProvider.notifier).searchServices(query);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Hizmet ara...',
                            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 15),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.tune, color: AppColors.primary),
                        onPressed: () => _showFilterSheet(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip('Tümü', Icons.apps, AppColors.primary, isSelected: mapState.selectedCategory == null),
                      _buildCategoryChip('Sağlık', Icons.local_hospital, AppColors.categoryHealth, categoryKey: 'health'),
                      _buildCategoryChip('Eğitim', Icons.school, AppColors.categoryEducation, categoryKey: 'education'),
                      _buildCategoryChip('Hukuki', Icons.gavel, AppColors.categoryLegal, categoryKey: 'legal'),
                      _buildCategoryChip('Barınma', Icons.home, AppColors.categoryHousing, categoryKey: 'housing'),
                      _buildCategoryChip('Sosyal', Icons.volunteer_activism, AppColors.categorySocialAid, categoryKey: 'social_aid'),
                      _buildCategoryChip('İş', Icons.work, AppColors.categoryEmployment, categoryKey: 'employment'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Loading göstergesi
          if (mapState.isLoading)
            Positioned(
              top: MediaQuery.of(context).padding.top + 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                      const SizedBox(width: 8),
                      const Text('Hizmetler yükleniyor...', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),

          // Hata mesajı
          if (mapState.error != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 120,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  mapState.error!,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Alt kart - hizmet listesi
          if (mapState.services.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: mapState.services.length,
                  itemBuilder: (context, index) {
                    final service = mapState.services[index];
                    return _buildServiceCard(service);
                  },
                ),
              ),
            ),

          if (_isLoadingLocation)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.2),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 160),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
              ),
              child: Column(
                children: [
                  _buildMapButton(Icons.add, () => _zoomIn()),
                  const Divider(height: 1),
                  _buildMapButton(Icons.remove, () => _zoomOut()),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: _goToMyLocation,
              child: _isLoadingLocation
                  ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                  : Icon(Icons.my_location, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _annotationManager = await mapboxMap.annotations.createPointAnnotationManager();
    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    // Listener: hizmetler yüklendiğinde marker'ları güncelle
    ref.listen<ServiceMapState>(serviceMapProvider, (prev, next) {
      if (prev?.services != next.services) {
        _updateMarkers(next.services);
      }
    });

    // İlk yükleme için mevcut verileri kontrol et
    final currentServices = ref.read(serviceMapProvider).services;
    if (currentServices.isNotEmpty) {
      _updateMarkers(currentServices);
    }
  }

  Future<void> _updateMarkers(List<ServiceEntity> services) async {
    if (_annotationManager == null) return;
    await _annotationManager!.deleteAll();

    for (final service in services) {
      final color = AppColors.getCategoryColor(service.category);
      final name = service.getLocalizedName('tr');

      final options = PointAnnotationOptions(
        geometry: Point(coordinates: Position(service.longitude, service.latitude)),
        iconSize: 1.2,
        textField: name.length > 20 ? '${name.substring(0, 20)}...' : name,
        textSize: 10,
        textOffset: [0, 2.0],
        textColor: color.toARGB32(),
        textHaloColor: Colors.white.toARGB32(),
        textHaloWidth: 1.5,
      );
      await _annotationManager!.create(options);
    }
  }

  Future<void> _goToMyLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final position = await LocationHelper.getCurrentPosition();
      await _mapboxMap?.flyTo(
        CameraOptions(center: Point(coordinates: Position(position.longitude, position.latitude)), zoom: 15.0),
        MapAnimationOptions(duration: 1500),
      );
      // Yeni konumda hizmetleri yükle
      ref.read(serviceMapProvider.notifier).loadNearbyServices(lat: position.latitude, lng: position.longitude);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _zoomIn() async {
    final cam = await _mapboxMap?.getCameraState();
    if (cam != null) {
      await _mapboxMap?.flyTo(CameraOptions(zoom: cam.zoom + 1), MapAnimationOptions(duration: 300));
    }
  }

  Future<void> _zoomOut() async {
    final cam = await _mapboxMap?.getCameraState();
    if (cam != null) {
      await _mapboxMap?.flyTo(CameraOptions(zoom: cam.zoom - 1), MapAnimationOptions(duration: 300));
    }
  }

  Widget _buildMapButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(10), child: Icon(icon, size: 22, color: AppColors.textPrimary)),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color color, {bool isSelected = false, String? categoryKey}) {
    final mapState = ref.watch(serviceMapProvider);
    final bool isActive = (categoryKey != null && mapState.selectedCategory == categoryKey) || isSelected;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.white : color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isActive ? Colors.white : AppColors.textPrimary, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
          ],
        ),
        selected: isActive,
        selectedColor: color,
        backgroundColor: Colors.white,
        elevation: isActive ? 3 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isActive ? color : Colors.grey.shade300)),
        onSelected: (_) {
          ref.read(serviceMapProvider.notifier).setCategory(label == 'Tümü' ? null : categoryKey);
        },
      ),
    );
  }

  Widget _buildServiceCard(ServiceEntity service) {
    final color = AppColors.getCategoryColor(service.category);
    final name = service.getLocalizedName('tr');
    final address = service.getLocalizedAddress('tr');

    return GestureDetector(
      onTap: () {
        _mapboxMap?.flyTo(
          CameraOptions(center: Point(coordinates: Position(service.longitude, service.latitude)), zoom: 16),
          MapAnimationOptions(duration: 800),
        );
        context.goNamed('service-detail', pathParameters: {'id': service.id});
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: Icon(_getCategoryIcon(service.category), color: color, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        if (service.distanceKm != null)
                          Text('${service.distanceKm!.toStringAsFixed(1)} km', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(child: Text(address, style: TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'health': return Icons.local_hospital;
      case 'education': return Icons.school;
      case 'legal': return Icons.gavel;
      case 'housing': return Icons.home;
      case 'social_aid': return Icons.volunteer_activism;
      case 'employment': return Icons.work;
      case 'community': return Icons.people;
      default: return Icons.place;
    }
  }

  void _showFilterSheet(BuildContext context) {
    final mapState = ref.read(serviceMapProvider);
    double distance = mapState.radiusKm.toDouble();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 20),
                  Text('Filtreler', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text('Mesafe: ${distance.round()} km', style: Theme.of(context).textTheme.titleMedium),
                  Slider(value: distance, min: 1, max: 50, divisions: 49, activeColor: AppColors.primary, label: '${distance.round()} km', onChanged: (v) => setModalState(() => distance = v)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(serviceMapProvider.notifier).setRadius(distance.round());
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: const Text('Uygula'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}