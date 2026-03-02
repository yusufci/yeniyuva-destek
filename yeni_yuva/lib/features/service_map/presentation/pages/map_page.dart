import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/location_helper.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;
  String? _selectedCategory;
  bool _isLoadingLocation = false;
  
  // Varsayılan konum: İstanbul
  static const _defaultLat = 41.0082;
  static const _defaultLng = 28.9784;

  // Mock hizmet noktaları
  final _mockServices = [
    _MockService('1', 'Göçmen Sağlık Merkezi', 'health', 41.0122, 28.9760, 'Fatih, İstanbul'),
    _MockService('2', 'Mülteci Eğitim Derneği', 'education', 41.0055, 28.9830, 'Sultanahmet, İstanbul'),
    _MockService('3', 'Hukuki Yardım Bürosu', 'legal', 41.0185, 28.9690, 'Fener, İstanbul'),
    _MockService('4', 'Barınma Destek Merkezi', 'housing', 41.0033, 28.9920, 'Eminönü, İstanbul'),
    _MockService('5', 'Sosyal Yardım Derneği', 'social_aid', 41.0200, 28.9550, 'Balat, İstanbul'),
    _MockService('6', 'İş Bulma Kurumu', 'employment', 41.0145, 28.9845, 'Unkapanı, İstanbul'),
    _MockService('7', 'Topluluk Merkezi', 'community', 41.0088, 28.9710, 'Aksaray, İstanbul'),
    _MockService('8', 'Çocuk Sağlığı Polikliniği', 'health', 41.0165, 28.9780, 'Edirnekapı, İstanbul'),
    _MockService('9', 'Dil Kursu', 'education', 41.0095, 28.9900, 'Sirkeci, İstanbul'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Mapbox Harita
          MapWidget(
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(_defaultLng, _defaultLat)),
              zoom: 13.0,
              bearing: 0,
              pitch: 0,
            ),
            styleUri: MapboxStyles.STANDARD,
            onMapCreated: _onMapCreated,
          ),

          // Üst bar - Arama ve Filtre
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Arama çubuğu
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

                // Kategori chip'leri
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip('Tümü', Icons.apps, AppColors.primary, isSelected: _selectedCategory == null),
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

          // Alt kart - seçili hizmet listesi
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  final service = _filteredServices[index];
                  return _buildServiceCard(service);
                },
              ),
            ),
          ),

          // Loading overlay
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
            // Zoom kontrolleri
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
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
            // Konumuma git
            FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: _goToMyLocation,
              child: _isLoadingLocation
                  ? SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    )
                  : Icon(Icons.my_location, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  List<_MockService> get _filteredServices {
    if (_selectedCategory == null) return _mockServices;
    return _mockServices.where((s) => s.category == _selectedCategory).toList();
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    // Annotation manager oluştur
    _annotationManager = await mapboxMap.annotations.createPointAnnotationManager();

    // Harita ayarları
    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    await mapboxMap.compass.updateSettings(CompassSettings(enabled: true));
    await mapboxMap.attribution.updateSettings(AttributionSettings(
      marginBottom: 160,
    ));

    // Mock marker'ları ekle
    _addServiceMarkers();
  }

  Future<void> _addServiceMarkers() async {
    if (_annotationManager == null) return;

    // Önce mevcut annotation'ları temizle
    await _annotationManager!.deleteAll();

    final services = _filteredServices;
    
    for (final service in services) {
      final color = AppColors.getCategoryColor(service.category);
      
      final options = PointAnnotationOptions(
        geometry: Point(coordinates: Position(service.lng, service.lat)),
        iconSize: 1.2,
        textField: service.name.length > 20 ? '${service.name.substring(0, 20)}...' : service.name,
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
        CameraOptions(
          center: Point(coordinates: Position(position.longitude, position.latitude)),
          zoom: 15.0,
        ),
        MapAnimationOptions(duration: 1500),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _zoomIn() async {
    final currentCamera = await _mapboxMap?.getCameraState();
    if (currentCamera != null) {
      await _mapboxMap?.flyTo(
        CameraOptions(zoom: currentCamera.zoom + 1),
        MapAnimationOptions(duration: 300),
      );
    }
  }

  Future<void> _zoomOut() async {
    final currentCamera = await _mapboxMap?.getCameraState();
    if (currentCamera != null) {
      await _mapboxMap?.flyTo(
        CameraOptions(zoom: currentCamera.zoom - 1),
        MapAnimationOptions(duration: 300),
      );
    }
  }

  Future<void> _flyToService(_MockService service) async {
    await _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(service.lng, service.lat)),
        zoom: 16.0,
      ),
      MapAnimationOptions(duration: 800),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 22, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color color, {bool isSelected = false, String? categoryKey}) {
    final bool isActive = (categoryKey != null && _selectedCategory == categoryKey) || isSelected;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
        selected: isActive,
        selectedColor: color,
        backgroundColor: Colors.white,
        elevation: isActive ? 3 : 1,
        shadowColor: color.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isActive ? color : Colors.grey.shade300),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = label == 'Tümü' ? null : categoryKey;
          });
          _addServiceMarkers();
        },
      ),
    );
  }

  Widget _buildServiceCard(_MockService service) {
    final color = AppColors.getCategoryColor(service.category);

    return GestureDetector(
      onTap: () {
        _flyToService(service);
        context.goNamed('service-detail', pathParameters: {'id': service.id});
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
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
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_getCategoryIcon(service.category), color: color, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getCategoryLabel(service.category),
                            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                          ),
                        ),
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
                  Expanded(
                    child: Text(
                      service.address,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 6, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text('Açık', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
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

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'health': return 'Sağlık';
      case 'education': return 'Eğitim';
      case 'legal': return 'Hukuki';
      case 'housing': return 'Barınma';
      case 'social_aid': return 'Sosyal Yardım';
      case 'employment': return 'İş';
      case 'community': return 'Topluluk';
      default: return category;
    }
  }

  void _showFilterSheet(BuildContext context) {
    double distance = 10;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Filtreler', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text('Mesafe: ${distance.round()} km', style: Theme.of(context).textTheme.titleMedium),
                  Slider(
                    value: distance,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    activeColor: AppColors.primary,
                    label: '${distance.round()} km',
                    onChanged: (v) => setModalState(() => distance = v),
                  ),
                  const SizedBox(height: 12),
                  Text('Konuşulan Dil', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(label: const Text('Türkçe'), selected: true, onSelected: (v) {}, selectedColor: AppColors.primary.withValues(alpha: 0.2)),
                      FilterChip(label: const Text('Arapça'), selected: false, onSelected: (v) {}),
                      FilterChip(label: const Text('İngilizce'), selected: false, onSelected: (v) {}),
                      FilterChip(label: const Text('Farsça'), selected: false, onSelected: (v) {}),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
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

class _MockService {
  final String id;
  final String name;
  final String category;
  final double lat;
  final double lng;
  final String address;

  _MockService(this.id, this.name, this.category, this.lat, this.lng, this.address);
}